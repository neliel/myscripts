module Helpers.Directory
( copyAnyway
, deleteAnyway
, fDirList
) where

import System.Directory
import System.Cmd (rawSystem)
import Data.List  ( (\\) )
import System.Exit

fDirList :: [String] -> [String]
fDirList = ( \\ [".",".."] )

-- | Copy arg to dest wether it's a file or a folder
copyAnyway :: FilePath -> FilePath -> IO ( Maybe ExitCode )
copyAnyway dest arg = do
    fileOrNotArg  <- doesFileExist arg
    dirOrNotArg   <- doesDirectoryExist arg
    dirOrNotDest  <- doesDirectoryExist dest
    if fileOrNotArg || dirOrNotArg && dirOrNotDest
    then do
        code <- rawSystem "cp" ["-r",arg,dest]
        return $ Just code
    else return Nothing


-- |  Delete the arg wether it's a file or a folder
deleteAnyway :: FilePath -> IO ( Maybe ExitCode )
deleteAnyway arg = do
    fileOrNotArg  <- doesFileExist arg
    dirOrNotArg   <- doesDirectoryExist arg
    if fileOrNotArg
    then do
        code <- rawSystem "rm" ["-f",arg]
        return $ Just code
    else if dirOrNotArg
         then do
             code <- rawSystem "rm" ["-rf",arg]
             return $ Just code
         else return Nothing

--EOF
