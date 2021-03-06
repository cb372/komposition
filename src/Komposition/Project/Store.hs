{-# OPTIONS_GHC -fno-warn-orphans #-}
{-# LANGUAGE RecordWildCards #-}
module Komposition.Project.Store
  ( readProjectFile
  , writeProjectFile
  ) where

import           Komposition.Prelude       hiding (Type, list)

import           Data.Binary           (Binary)
import qualified Data.Binary           as Binary
import           Data.Time.Clock       (diffTimeToPicoseconds,
                                        picosecondsToDiffTime)

import           Komposition.Composition
import           Komposition.Duration
import           Komposition.Library
import           Komposition.Project
import           Komposition.VideoSettings

instance Binary AssetMetadata
instance Binary VideoAsset
instance Binary AudioAsset
instance Binary ProxyPath
instance Binary OriginalPath

instance Binary Duration where
  get = Duration . picosecondsToDiffTime <$> Binary.get
  put (Duration d) = Binary.put (diffTimeToPicoseconds d)

instance Binary TimeSpan

instance Binary a => Binary (VideoPart a)
instance Binary a => Binary (AudioPart a)
instance Binary a => Binary (Parallel a)
instance Binary a => Binary (Sequence a)
instance Binary a => Binary (Timeline a)
instance Binary Library
instance Binary Resolution
instance Binary VideoSettings
instance Binary Project

readProjectFile :: FilePath -> IO Project
readProjectFile = Binary.decodeFile

writeProjectFile :: FilePath -> Project -> IO ()
writeProjectFile = Binary.encodeFile
