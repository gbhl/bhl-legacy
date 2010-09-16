<?php

$info = array(

  'schemes' => array(
    '#ffffff,#3e4967,#668040,#485a2d,#000000' => t('Green (Default)'),
    '#ffffff,#3e4967,#7b0f0f,#560b0b,#000000' => t('Red'),
  ),

  'copy' => array(
    'images/bullet.gif',
    'images/bullet_minus.png',
    'images/bullet_plus.png',
    'images/quote.png',
    'images/bg.gif',
    'images/bg2.gif',
  ),

  // CSS files (excluding @import) to rewrite with new color scheme.
  'css' => array(
    'style.css',
  ),

  // Gradient added as dummy; this theme does not color images.
  'gradient' => array(0, 0, 1, 2),

  // Fill added as dummy; this theme does not color images.
  'fill' => array(
    'base' => array(0, 2, 1, 1),
  ),
  
  // Slice added as dummy; this theme does not color images.
  'slices' => array(
    'images/dummy.png'                      => array(0, 0, 1, 1),
  ),

  'blend_target' => '#ffffff',
  
    // Preview files.
  'preview_image' => 'color/preview.png',
  'preview_css' => 'color/preview.css',

  // Base file for image generation, this is a dummy as the theme does 
  // not use color images.
  'base_image' => 'color/base.png',
  
);
