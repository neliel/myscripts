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




-- | La plage "SS" est interdite en France; le nb de combinaisons limité à 675 324
plaqueFra :: IO String
plaqueFra = do
  g <- makeSystem
  return $ "SS-" ++ take 3 (randomRs ('0','9') g) ++ "-" ++ take 2 (randomRs ('A','Z') g)

genFra :: Int -> IO [String]
genFra n = do
  glist <- sequence $ take (n*2) $ repeat plaqueFra
  return $ take n $ nub $ glist

-- | Les voyelles ainsi que les lettres Q sont interdites
plaqueEsp :: IO String
plaqueEsp = do
  g <- makeSystem
  return $ take 4 (randomRs ('0','9') g) ++ " " ++ take 3 (randomRs ('A','Z') g)

genEsp :: Int -> IO [String]
genEsp n = do
  glist <- sequence $ take (n*10) $ repeat plaqueEsp
  return $ take n $ nub $ filter (\x -> any (\y -> y `elem` "AEIOUYQ") x) glist

-- | La plage allant de 30000 à 49999 n'est pas utilisée
plaqueDnk :: IO String
plaqueDnk = do
  g <- makeSystem
  return $ take 2 (randomRs ('A','Z') g) ++ " " ++ take 5 (randomRs ('A','Z') g)

genDnk :: Int -> IO [String]
genDnk n = do
  glist <- sequence $ take (n*2) $ repeat plaqueDnk
  return $ take n $ nub $ glist

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
        list <- (genDnk $ read n)
        writeFile fi $ unlines list
      "esp" -> do
        list <- (genEsp $ read n)
        writeFile fi $ unlines list
      --"fin" -> writeFile (unlines $ genFin $ read n) fi
      "fra" -> do
        list <- (genFra $ read n)
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
