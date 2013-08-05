#!/usr/bin/env runhaskell
{-# LANGUAGE OverloadedStrings #-}

import System.Directory
import System.FilePath
import System.Random
import System.Platform
import Helpers.AES
import System.Environment (getArgs)
import System.Cmd         (rawSystem)
import Data.List          ( (\\) )
import qualified Data.List.Split        as L
import qualified Codec.Archive.Tar      as Tar

key :: String
key =
  case os_type of
    MS_Windows -> "C:\\Users\\Sarfraz\\_keyrc"
    Unix       -> "/home/sarfraz/.keyrc"

fDirList :: [String] -> [String]
fDirList = ( \\ [".",".."] )

-- | Create an encrypted tarball from a file
func :: String -> FilePath -> IO ()
func key name = do
    Tar.create tarName "." [name]
    encryptFromToFile key tarName crptName
    removeFile tarName
    return ()
  where
    tarName       = name <.> ".tar"
    crptName      = name <.> ".tar.crpt"

-- | Create an encrypted tarball for each not encrypted file in the current directory
funcMapToCurrentDirectory :: String -> IO ()
funcMapToCurrentDirectory key = do
    contentDir <- getDirectoryContents "."
    mapM_ (func key) $ filter (\x -> (takeExtension x) /= ".crpt") $ fDirList contentDir

-- | Decrypt an encrypted tarball from a file
unfunc :: String -> FilePath -> IO ()
unfunc key name = do
    decryptFromToFile key crptName tarName
    Tar.extract "." tarName
    removeFile tarName
    return ()
  where
    tName          = head $ L.split (L.onSublist ".tar.crpt") name
    tarName        = tName <.> ".tar"
    crptName       = tName <.> ".tar.crpt"

-- | Decrypt an encrypted tarball for each encrypted file in the current directory
unfuncMapToCurrentDirectory :: String -> IO ()
unfuncMapToCurrentDirectory key = do
    contentDir <- getDirectoryContents "."
    mapM_ (unfunc key) $ filter (\x -> (takeExtension x) == ".crpt") $ fDirList contentDir

main :: IO ()
main = do
    args <- getArgs
    case args of
       (cryptmode:typemode:end:_) ->
         case cryptmode of
           "-e" ->
             case typemode of
               "-f" -> func key end
               "-d" -> do
                 setCurrentDirectory end
                 funcMapToCurrentDirectory key
           "-u" -> do
             case typemode of
               "-f" -> unfunc key end
               "-d" -> do
                 setCurrentDirectory end
                 unfuncMapToCurrentDirectory key
           _    -> error $ "invalid command arguments, "++cryptmode++" "++typemode++" "++end
       (cryptmode:end:_)          ->
         case cryptmode of
           "-e" -> func key end
           "-u" -> unfunc key end
           _    -> error $ "invalid command arguments, "++cryptmode++" "++end
       _                          -> error "invalid number of command arguments"
--EOF
