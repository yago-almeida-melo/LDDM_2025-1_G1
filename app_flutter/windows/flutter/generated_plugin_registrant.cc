//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <bottom_navbar_player/bottom_navbar_player_plugin_c_api.h>
#include <flutter_tts/flutter_tts_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  BottomNavbarPlayerPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("BottomNavbarPlayerPluginCApi"));
  FlutterTtsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterTtsPlugin"));
}
