#!/usr/bin/env runhaskell

-- makesrc.hs
-- Crée le: 10 Fév. 2013 à 21h40
-- License: GPLv3

import System.Environment (getArgs)
import System.Cmd         (rawSystem)
import System.Directory
import System.FilePath
import System.Platform

main :: IO ()
main = do
    [file] <- getArgs
    let
      nameFile = takeBaseName file
    rawSystem "hmake" [nameFile]
    home <- getHomeDirectory
    let
      nameExe  =
        case os_type of
          MS_Windows -> nameFile ++ ".exe"
          Unix       -> nameFile
      homeFile =
        case os_type of
          MS_Windows -> home ++ "\\.opt\\bin\\" ++ nameExe
          Unix       -> home ++ "/.opt/bin/" ++ nameExe
    copyFile nameExe homeFile
    removeFile nameExe
--EOF
