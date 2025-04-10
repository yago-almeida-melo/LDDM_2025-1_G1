//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <bottom_navbar_player/bottom_navbar_player_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) bottom_navbar_player_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "BottomNavbarPlayerPlugin");
  bottom_navbar_player_plugin_register_with_registrar(bottom_navbar_player_registrar);
}
