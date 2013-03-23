#!/usr/bin/env runhaskell

import System.Environment (getArgs)
import System.Cmd         (rawSystem)
import System.Directory
import System.FilePath
import System.Platform
import Data.List ( (\\) )

hmake :: FilePath -> IO ()
hmake arg = do
  getDirectoryContents "." >>= \x -> mapM_ removeFile $ fExe $ fDir x
  rawSystem "ghc" ["-O2", "-rtsopts", "--make", ban]
  case os_type of
    MS_Windows -> do
      rawSystem "strip" [ban ++ ".exe"]
      return ()
    Unix       -> do
      rawSystem "strip" [ban]
      return ()
  getDirectoryContents "." >>= \x -> mapM_ removeFile $ fObj $ fDir x
 where
  ban  = takeBaseName arg
  fExe = filter (\x -> takeExtension x `elem` [".exe",""] && takeBaseName x == takeBaseName arg)
  fObj = filter (\x -> takeExtension x `elem` [".hi", ".o"])
  fDir = (\\ [".",".."])

main :: IO ()
main = do
  args <- getArgs
  case args of
    (file:_) -> do
      hmake file
      putStrLn "Done"
    _        -> error "invalid input, stopped"

--EOF
