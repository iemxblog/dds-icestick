{-|
Module		: Main
Description	: Interface for an FPGA-based DDS generator
Copyright	: (c) Maxime ANDRE, 2015
License		: GPL-2
Maintainer	: iemxblog@gmail.com
Stability	: experimental
Portability	: POSIX
-}
module Main (
	main
) where

import Data.Word
import Data.Bits
import Data.List
import Control.Monad
import System.IO
import System.Hardware.Serialport
import qualified Data.ByteString as B

data Command = Byte Int Word8 | Enable | Disable | Set deriving (Eq, Show)

ack = 97

-- | Translates 'Command' to binary, in order to send it over the serial port.
commandToWord8 :: Command -> [Word8]
commandToWord8 (Byte i w) = [48+fromIntegral i, w]
commandToWord8 Enable = [101]
commandToWord8 Disable = [100]
commandToWord8 Set = [115]

commandsToWord8 :: [Command] -> [Word8]
commandsToWord8 = concatMap commandToWord8

-- | Splits an integer into a list of bytes ('Word8'). LSB are first in the list.
-- Used to split the tuning word, to send it over the serial port.
splitIntegral :: (Bits a, Integral a) => a 		-- ^ The integer to split.
					-> [Word8]	-- ^ The resulting list of bytes.
splitIntegral = unfoldr (\b -> if b == 0 then Nothing else Just (fromIntegral (b .&. 255), shift b (-8)))

-- | Transforms a list of bytes into an integer (sort of bit concatenation). LSB are first in the list.
unsplitIntegral :: (Bits a, Integral a) => [Word8]	-- ^ The list of bytes.
					-> a		-- ^ The resulting integer
unsplitIntegral = foldr (\a b -> fromIntegral a + shift b 8) 0 


-- | Calculates the tuning word from a given frequency.
tuningWord :: (RealFrac f, Integral i) => i	-- ^ fClk : The clock of the FPGA in Hz (12MHz for the Icestick)
					-> i 	-- ^ twBits : The size of the tuning word (in bits)
					-> f	-- ^ f : The input frequency
					-> i	-- ^ The resulting tuning word.
tuningWord fClk twBits f = round $ 2^twBits * f / fromIntegral fClk

-- | Calculates the frequency from a given tuning word.
frequency :: (Integral i , Fractional f) => i	-- ^ fClk : The clock of the FPGA in Hz (12MHz for the Icestick)
					-> i 	-- ^ twBits : The size of the tuning word (in bits)
					-> i 	-- ^ m : The input tuning word
					-> f	-- ^ The resulting frequency
frequency fClk twBits m =  fromIntegral (m * fClk) / 2^twBits

-- | Generates a list of commands to send the tuning word.
genCommandsTW :: RealFrac f => 	f 		-- ^ f : Desired frequenct
				-> [Command]	-- ^ Resulting command
genCommandsTW f = zipWith Byte [0..] (make5 (splitIntegral . tuningWord fClk twBits $ f))
	where 
		make5 = take 5 . (++ repeat 0)
		fClk = 12000000
		twBits = 40 :: Int

sendCommand :: SerialPort -> Command -> IO ()
sendCommand serial c = do
	send serial $ B.pack (commandToWord8 c)
	putStr "o"
	hFlush stdout
	b <- recv serial 1
	case B.unpack b of
		[ack] -> putStr "." >> hFlush stdout
		_ -> putStr "!" >> hFlush stdout

sendCommands :: SerialPort -> [Command] -> IO ()
sendCommands serial cs = (sequence_ . map (sendCommand serial)) cs >> putStrLn ""
		
--loop :: SerialPort -> IO ()
loop serial = do
	putStr "> "
	hFlush stdout
	s <- getLine
	case s of
		"enable" -> sendCommands serial [Enable] >> loop serial
		"disable" -> sendCommands serial [Disable] >> loop serial
		"set" -> sendCommands serial [Set] >> loop serial
		"f" -> do
				putStr "f="
				hFlush stdout
				sf <- getLine
				let f = read sf 
				sendCommands serial $ genCommandsTW f
				loop serial
		"help" -> putStrLn "Available commands : enable, disable, set, f, help, exit" >> loop serial
		"exit" -> return ()
		_ -> putStrLn "Invalid command" >> loop serial

main :: IO ()
main = do
	putStrLn "Opening serial port..."
	withSerial "/dev/ttyUSB1" defaultSerialSettings { commSpeed = CS9600 } loop
	putStrLn "Serial port closed."

