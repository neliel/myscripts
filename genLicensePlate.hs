#!/usr/bin/env runhaskell
{-# LANGUAGE OverloadedStrings #-}

-- Type   : script
-- Crée le: 26 Fév. 2013 à 10h54
-- Auteur : Sarfraz Kapasi
-- License: GPLv3

import System.Environment   (getArgs)
import Data.List            (nub)
import System.Random
import Crypto.Random.AESCtr (makeSystem)
import Control.Applicative  ( (<$>) )
import Control.Monad        (replicateM)

randomItem :: [a] -> IO a
randomItem xs = (xs!!)  <$> randomRIO (0, length xs - 1)

genFromMask :: [String] -> IO String
genFromMask = mapM randomItem

genMeSome :: [String] -> Int -> IO [String]
genMeSome mask n = do
  glist <- replicateM (n*10) (genFromMask mask)
  return $ take n $ nub glist

-- | La plage "SS" est interdite en France; le nb de combinaisons limité à 675 324
genFra :: Int -> IO [String]
genFra = genMeSome ["S","S","-",['0'..'9'],['0'..'9'],['0'..'9'],"-",['A'..'Z'],['A'..'Z']]

-- | Les voyelles ainsi que les lettres Q sont interdites
genEsp :: Int -> IO [String]
genEsp = genMeSome [['0'..'9'],['0'..'9'],['0'..'9'],['0'..'9']," ",['A'..'Z'],"AEIOUYQ",['A'..'Z']]

-- | La plage allant de 30000 à 49999 n'est pas utilisée
genDnk :: Int -> IO [String]
genDnk = genMeSome [['A'..'Z'],['A'..'Z']," ","34",['0','9'],['0','9'],['0','9'],['0','9']]

main :: IO ()
main = do
  g    <- makeSystem
  args <- getArgs
  case args of
    (mo:fi:n:_) -> case mo of
      --"aus" -> writeFile (unlines $ genAus $ read n) fi
      --"bra" -> writeFile (unlines $ genBra $ read n) fi
      --"deu" -> writeFile (unlines $ genDeu $ read n) fi
      "dnk" -> do
        list <- genDnk $ read n
        writeFile fi $ unlines list
      "esp" -> do
        list <- genEsp $ read n
        writeFile fi $ unlines list
      --"fin" -> writeFile (unlines $ genFin $ read n) fi
      "fra" -> do
        list <- genFra $ read n
        writeFile fi $ unlines list
      --"gbr" -> writeFile (unlines $ genGbr $ read n) fi
      --"hun" -> writeFile (unlines $ genHun $ read n) fi
      --"nld" -> writeFile (unlines $ genNld $ read n) fi
      --"nor" -> writeFile (unlines $ genNor $ read n) fi
      --"pol" -> writeFile (unlines $ genPol $ read n) fi
      --"svn" -> writeFile (unlines $ genSvn $ read n) fi
      --"swe" -> writeFile (unlines $ genSwe $ read n) fi
      --"usa" -> writeFile (unlines $ genUsa $ read n) fi
      _     -> error "country is not supported"
    _           -> error "invalid input, format is: genLicensePlate country file number"



--EOF
