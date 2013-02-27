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

writeIt ::  FilePath -> Int -> [String] -> IO ()
writeIt fi n mask = do
   glist <- genMeSome mask n
   writeFile fi $ unlines glist

maj :: String
maj = ['A'..'Z']

numa :: String
numa = ['0'..'9']


-- | La plage "SS" est interdite en France; le nb de combinaisons limité à 675 324
genFra :: [String]
genFra = ["S","S","-",numa,numa,numa,"-",maj,maj]
-- | Les voyelles ainsi que les lettres Q sont interdites
genEsp :: [String]
genEsp = [numa,numa,numa,numa," ",maj,"AEIOUYQ",maj]
-- | La plage allant de 30000 à 49999 n'est pas utilisée
genDnk :: [String]
genDnk = [maj,maj," ","34",numa,numa,numa,numa]
-- | la lettre Z est utilisée pour identifié une région en random
genGbr :: [String]
genGbr = ["Z",maj,numa,numa," ",maj,maj,maj]
-- | Les allemands ne veulent plus se rappeler du nazisme
genDeu :: [String]
genDeu = ["S","S",maj,numa,numa,numa,numa]
-- | la partie numerique ne peut pas commencer par 0
genFin :: [String]
genFin = [maj,maj,maj,"-","0",numa,numa]
-- | La génération est sequentielle; les Z families vont prendre un peu de temps
genHun :: [String]
genHun = ["Z",maj,maj,"-",numa,numa,numa]
-- | Même topo avec les sigles SD et SS
genNld :: [String]
genNld = [numa,"-","S","DS","ZB","-",numa,numa]
-- | Même topo avec les sigles SD et SS
genNor :: [String]
genNor = ["NS","S"," ",numa,numa,numa,numa,numa]
-- | On introduit des lettres interdites
genPol :: [String]
genPol = [maj,maj," ",numa,numa,numa,"BDIOZQ",numa]
-- | les deux premiéres lettres forment un code region
genSvn :: [String]
genSvn = ["ADFHIQTUVWXYZ","ADFHIQTUVWXYZ"," ",maj,numa,"-",numa,numa,numa]
--- | Les suedois n'utilisent pas la lettre Q
genSwe :: [String]
genSwe = [maj,"Q",maj," ",numa,numa,numa]
-- | Certaines regions n'utilisent aucune des plages libres
genBra :: [String]
genBra = ["VWXYZ",maj,maj," ",numa,numa,numa,numa]
-- | Plaque de la californie qui s'incremente sequentiellement
genUsa :: [String]
genUsa = ["9","Z",maj,maj,numa,numa,numa]
-- |
genAus :: [String]
genAus = [maj,maj,maj," ",numa,numa,numa]

main :: IO ()
main = do
  g    <- makeSystem
  args <- getArgs
  case args of
    (mo:fi:n:_) -> case mo of
      "aus" -> writeIt fi (read n) genAus
      "bra" -> writeIt fi (read n) genBra
      "deu" -> writeIt fi (read n) genDeu
      "dnk" -> writeIt fi (read n) genDnk
      "esp" -> writeIt fi (read n) genEsp
      "fin" -> writeIt fi (read n) genFin
      "fra" -> writeIt fi (read n) genFra
      "gbr" -> writeIt fi (read n) genGbr
      "hun" -> writeIt fi (read n) genHun
      "nld" -> writeIt fi (read n) genNld
      "nor" -> writeIt fi (read n) genNor
      "pol" -> writeIt fi (read n) genPol
      "svn" -> writeIt fi (read n) genSvn
      "swe" -> writeIt fi (read n) genSwe
      "usa" -> writeIt fi (read n) genUsa
      _     -> error "country is not supported"
    _           -> error "wrong input, format is: genLicensePlate country file number"

--EOF
