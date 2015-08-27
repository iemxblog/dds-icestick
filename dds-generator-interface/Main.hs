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

data Command = Byte Int Word8 | Enable | Disable | Set deriving (Eq, Show)

commandToWord8 :: Command -> [Word8]
commandToWord8 (Byte i w) = [fromIntegral i, w]
commandToWord8 Enable = [4]
commandToWord8 Disable = [5]
commandToWord8 Set = [6]

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

genCommand :: RealFrac f => f -> [Command]
genCommand f = zipWith Byte [0..] (make4 (splitIntegral . tuningWord fClk twBits $ f))
	where 
		make4 = take 4 . (++ repeat 0)
		fClk = 12000000
		twBits = 32 :: Int



main :: IO ()
main = putStrLn "Hello, World!"
