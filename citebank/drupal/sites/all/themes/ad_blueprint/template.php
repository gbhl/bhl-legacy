<?php

/*
* Initialize theme settings
*/
if (is_null(theme_get_setting('ad_blueprint'))) {
  global $theme_key;

  $defaults = array(
    'ad_blueprint_layout' => 'fluid_95',
  );

  $settings = theme_get_settings($theme_key);
  if (module_exists('node')) {
    foreach (node_get_types() as $type => $name) {
      unset($settings['toggle_node_info_' . $type]);
    }
  }
  variable_set(
    str_replace('/', '_', 'theme_'. $theme_key .'_settings'),
    array_merge($defaults, $settings)
  );
  theme_get_setting('', TRUE);
}

/**
* Override or insert PHPTemplate variables into the templates.
*/
function phptemplate_preprocess_page(&$vars) {
  // Hook into color.module
  if (module_exists('color')) {
    _color_page_alter($vars);
  }
}

// Theme Settings Generated CSS
$custom_css = file_directory_path() .'/ad_blueprint/custom.css';
if (file_exists($custom_css)) {
  drupal_add_css($custom_css, 'theme', 'all', TRUE);
}
