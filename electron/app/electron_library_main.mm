// Copyright (c) 2013 GitHub, Inc.
// Use of this source code is governed by the MIT license that can be
// found in the LICENSE file.

#include "electron/app/electron_library_main.h"

#include "electron/app/electron_main_delegate.h"
#include "electron/app/node_main.h"
#include "electron/common/electron_command_line.h"
#include "base/at_exit.h"
#include "base/i18n/icu_util.h"
#include "base/mac/bundle_locations.h"
#include "base/mac/scoped_nsautorelease_pool.h"
#include "brightray/common/mac/main_application_bundle.h"
#include "content/public/app/content_main.h"

#if defined(OS_MACOSX)
int ElectronMain(int argc, const char* argv[]) {
  electron::ElectronMainDelegate delegate;
  content::ContentMainParams params(&delegate);
  params.argc = argc;
  params.argv = argv;
  electron::ElectronCommandLine::Init(argc, argv);
  return content::ContentMain(params);
}

int ElectronInitializeICUandStartNode(int argc, char *argv[]) {
  base::AtExitManager atexit_manager;
  base::mac::ScopedNSAutoreleasePool pool;
  base::mac::SetOverrideFrameworkBundlePath(
      brightray::MainApplicationBundlePath()
          .Append("Contents")
          .Append("Frameworks")
          .Append(ELECTRON_PRODUCT_NAME " Framework.framework"));
  base::i18n::InitializeICU();
  return electron::NodeMain(argc, argv);
}
#endif  // OS_MACOSX
