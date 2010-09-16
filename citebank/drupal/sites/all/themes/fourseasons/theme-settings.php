<?php

/**
* Implementation of THEMEHOOK_settings() function.
*
* @param $saved_settings
*   array An array of saved settings for this theme.
* @return
*   array A form array.
*/
function phptemplate_settings($saved_settings) {

  drupal_add_css('misc/farbtastic/farbtastic.css');
  drupal_add_js('misc/farbtastic/farbtastic.js');
  drupal_add_js('
    $(document).ready(function() {
      $("#colorpicker").farbtastic("#edit-fourseasons-basecolor");
    });
  ', 'inline');
  /*
   * The default values for the theme variables. Make sure $defaults exactly
   * matches the $defaults in the template.php file.
   */
  $defaults = array(
    'fourseasons_basecolor' => '#FF9900',
  );

  // Merge the saved variables and their default values
  $settings = array_merge($defaults, $saved_settings);

  // Create the form widgets using Forms API
  $form['fourseasons_basecolor'] = array(
    '#type' => 'textfield',
    '#title' => t('Four Seasons Base Color'),
    '#field_suffix' => '<div>'.t('Any color but the default color will replace the headerimage with a colored area. The default Theme-Color is').': #FF9900</div>',
    '#description' => '<div id="colorpicker"></div>',
    '#default_value' => $settings['fourseasons_basecolor'],
  );

  // Return the additional form widgets
  return $form;

}

?>