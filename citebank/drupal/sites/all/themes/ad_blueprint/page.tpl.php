<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="<?php print $language->language ?>" xml:lang="<?php print $language->language ?>">

<head>
  <title><?php print $head_title ?></title>
  <?php print $head ?>
  <?php print $styles ?>
  <!--[if lt IE 7]>
    <link rel="stylesheet" href="<?php print $base_path . $directory; ?>/ie_lt7.css" type="text/css">
  <![endif]-->
  <?php print $scripts ?>
  <script type="text/javascript"><?php // to avoid flash of unstyled content ?> </script>
</head>

<body id="<?php print str_replace("/", "-", str_replace("?q=", "", (trim($_SERVER['REQUEST_URI'], $base_path)))) ?>" class="<?php print $layout ?>">

<div <?php if ($sidebar_left2) {echo 'class="left-2-present"';} ?> id="wrapper1">
<div <?php if ($sidebar_right2) {echo 'class="right-2-present"';} ?> id="wrapper2">
<div id="wrapper3">

  <?php if ($page_top || $top_left || $top_right || $top_col13 || $top_col23 || $top_col33 || $top_col14 || $top_col24 || $top_col34 || $top_col44): ?>
    <div id="upper-regions">

      <?php if ($page_top): ?>
        <div id="page-top">
          <?php print $page_top; ?>
        </div>
      <?php endif; ?>
      
      <?php if ($top_left || $top_right): ?>
        <div class="clear-this">

          <?php if ($top_left): ?>
            <div class="col-left"><div class="col-left-inner"><div class="col-left-inner2">
            <?php // left-inner because of box model bug in IE 5. left-inner2 because of overflow bug in IE 5 & 6 ?>
              <?php print $top_left; ?>
            </div></div></div>
          <?php endif; ?>

          <?php if ($top_right): ?>
            <div class="col-right"><div class="col-right-inner"><div class="col-right-inner2">
            <?php // right-inner because of box model bug in IE 5. right-inner2 because of overflow bug in IE 5 & 6 ?>
              <?php print $top_right; ?>
            </div></div></div>
          <?php endif; ?>

        </div>
      <?php endif; ?>

      <?php if ($top_col13 || $top_col23 || $top_col33): ?>
        <div class="clear-this">

          <?php if ($top_col13): ?>
            <div class="col13"><div class="col13-inner"><div class="col13-inner2">
            <?php // col13-inner because of box model bug in IE 5. col13-inner2 because of overflow bug in IE 5 & 6 ?>
              <?php print $top_col13; ?>
            </div></div></div>
          <?php endif; ?>

          <?php if ($top_col23): ?>
            <div class="col23"><div class="col23-inner"><div class="col23-inner2">
            <?php // col23-inner because of box model bug in IE 5. col23-inner2 because of overflow bug in IE 5 & 6 ?>
              <?php print $top_col23; ?>
            </div></div></div>
          <?php endif; ?>

          <?php if ($top_col33): ?>
            <div class="col33"><div class="col33-inner"><div class="col33-inner2">
            <?php // col33-inner because of box model bug in IE 5. col33-inner2 because of overflow bug in IE 5 & 6 ?>
              <?php print $top_col33; ?>
            </div></div></div>
          <?php endif; ?>

        </div>
      <?php endif; ?>

      <?php if ($top_col14 || $top_col24 || $top_col34 || $top_col44): ?>
        <div class="clear-this">

          <?php if ($top_col14): ?>
            <div class="col14"><div class="col14-inner"><div class="col14-inner2">
            <?php // col14-inner because of box model bug in IE 5. col14-inner2 because of overflow bug in IE 5 & 6 ?>
              <?php print $top_col14; ?>
            </div></div></div>
          <?php endif; ?>

          <?php if ($top_col24): ?>
            <div class="col24"><div class="col24-inner"><div class="col24-inner2">
            <?php // col24-inner because of box model bug in IE 5. col24-inner2 because of overflow bug in IE 5 & 6 ?>
              <?php print $top_col24; ?>
            </div></div></div>
          <?php endif; ?>

          <?php if ($top_col34): ?>
            <div class="col34"><div class="col34-inner"><div class="col34-inner2">
            <?php // col34-inner because of box model bug in IE 5. col34-inner2 because of overflow bug in IE 5 & 6 ?>
              <?php print $top_col34; ?>
            </div></div></div>
          <?php endif; ?>

          <?php if ($top_col44): ?>
            <div class="col44"><div class="col44-inner"><div class="col44-inner2">
            <?php // col44-inner because of box model bug in IE 5. col44-inner2 because of overflow bug in IE 5 & 6 ?>
              <?php print $top_col44; ?>
            </div></div></div>
          <?php endif; ?>

        </div>
      <?php endif; ?>
    
    </div>
  <?php endif; ?>

  <div id="wrapper4">
    
    <div class="clear-block">

      <div id="header" class="clear-block">
      <div <?php if ($left_header && $right_header) {echo 'id="header-both"' ;}
                 elseif ($left_header)  {echo 'id="header-left"' ;}
                 elseif ($right_header)  {echo 'id="header-right"' ;}?> class="header-inner clear-block">

        <?php if ($search_box) : ?>
          <div id="search-box"><?php print str_replace('Search this site:','',$search_box) ?></div>
        <?php endif; ?>

        <div id="logo-sitename">
          <div class="clear-block">

            <?php if ($logo) { ?>
              <a href="<?php print $front_page ?>" title="<?php print t('Home') ?>" id="logo">
                <img src="<?php print $logo ?>" alt="<?php print t('Home') ?>" />
              </a>
            <?php } ?>

            <?php if ($site_name) { ?>
              <h1 class='site-name'>
                <a href="<?php print $front_page ?>" title="<?php print t('Home') ?>">
                  <?php print $site_name ?>
                </a>
              </h1>
            <?php } ?>

          </div>

          <?php if ($site_slogan) { ?>
            <h2 class='site-slogan'>
              <?php print $site_slogan ?>
            </h2>
          <?php } ?>
        </div>

      </div></div>
      
      <?php if ($left_header): ?>
        <div id="left-header">
          <?php print $left_header; ?>
        </div>
      <?php endif; ?>
      
      <?php if ($right_header): ?>
        <div id="right-header">
          <?php print $right_header; ?>
        </div>
      <?php endif; ?>

    </div>
    
    <div id="middle" class="clear-block">

      <?php if ($header): ?>
        <div id="header-region">
          <?php print $header ?>
        </div>
      <?php endif; ?>
      
      <?php if ($header_left || $header_right): ?>
        <div class="clear-this">

          <?php if ($header_left): ?>
            <div class="col-left"><div class="col-left-inner"><div class="col-left-inner2">
            <?php // left-inner because of box model bug in IE 5. left-inner2 because of overflow bug in IE 5 & 6 ?>
              <?php print $header_left; ?>
            </div></div></div>
          <?php endif; ?>

          <?php if ($header_right): ?>
            <div class="col-right"><div class="col-right-inner"><div class="col-right-inner2">
            <?php // right-inner because of box model bug in IE 5. right-inner2 because of overflow bug in IE 5 & 6 ?>
              <?php print $header_right; ?>
            </div></div></div>
          <?php endif; ?>

        </div>
      <?php endif; ?>

      <?php if ($header_col13 || $header_col23 || $header_col33): ?>
        <div class="clear-this">

          <?php if ($header_col13): ?>
            <div class="col13"><div class="col13-inner"><div class="col13-inner2">
            <?php // col13-inner because of box model bug in IE 5. col13-inner2 because of overflow bug in IE 5 & 6 ?>
              <?php print $header_col13; ?>
            </div></div></div>
          <?php endif; ?>

          <?php if ($header_col23): ?>
            <div class="col23"><div class="col23-inner"><div class="col23-inner2">
            <?php // col23-inner because of box model bug in IE 5. col23-inner2 because of overflow bug in IE 5 & 6 ?>
              <?php print $header_col23; ?>
            </div></div></div>
          <?php endif; ?>

          <?php if ($header_col33): ?>
            <div class="col33"><div class="col33-inner"><div class="col33-inner2">
            <?php // col33-inner because of box model bug in IE 5. col33-inner2 because of overflow bug in IE 5 & 6 ?>
              <?php print $header_col33; ?>
            </div></div></div>
          <?php endif; ?>

        </div>
      <?php endif; ?>

      <div id="primary">
        <?php print theme('links', $primary_links); ?>
      </div>

      <?php if ($secondary_links): ?>
        <div id="secondary">
          <?php print theme('links', $secondary_links); ?>
        </div>
      <?php endif; ?>

      <div id="main-outer"><div id="main-outer2"><div><div id="main"><div id="main2"><div id="main-inner"><div id="main-inner2">
      <?php // main-inner because of box model bug in IE 5. main-inner2 because of overflow bug in IE 5 & 6 ?>

        <?php if ($mission) { ?>
          <div id="mission">
            <?php print $mission ?>
          </div>
        <?php } ?>

        <div class="inner">

          <?php print $breadcrumb ?>

          <?php print $above_content ?>
          
          <?php if ($above_left || $above_right): ?>
            <div class="clear-this">

              <?php if ($above_left): ?>
                <div class="col-left"><div class="col-left-inner"><div class="col-left-inner2">
                <?php // left-inner because of box model bug in IE 5. left-inner2 because of overflow bug in IE 5 & 6 ?>
                  <?php print $above_left; ?>
                </div></div></div>
              <?php endif; ?>

              <?php if ($above_right): ?>
                <div class="col-right"><div class="col-right-inner"><div class="col-right-inner2">
                <?php // right-inner because of box model bug in IE 5. right-inner2 because of overflow bug in IE 5 & 6 ?>
                  <?php print $above_right; ?>
                </div></div></div>
              <?php endif; ?>

            </div>
          <?php endif; ?>

          <?php if ($title): ?>
            <h1 class="title">
              <?php print $title ?>
            </h1>
          <?php endif; ?>

          <?php if ($tabs){ ?>
            <div class="tabs">
              <?php print $tabs ?>
            </div>
          <?php } ?>

          <?php print $help ?>

          <?php if ($show_messages && $messages) {print $messages;}; ?>
            
          <?php print $content ?>

          <?php if ($below_left || $below_right): ?>
            <div class="clear-this">

              <?php if ($below_left): ?>
                <div class="col-left"><div class="col-left-inner"><div class="col-left-inner2">
                <?php // left-inner because of box model bug in IE 5. left-inner2 because of overflow bug in IE 5 & 6 ?>
                  <?php print $below_left; ?>
                </div></div></div>
              <?php endif; ?>

              <?php if ($below_right): ?>
                <div class="col-right"><div class="col-right-inner"><div class="col-right-inner2">
                <?php // right-inner because of box model bug in IE 5. right-inner2 because of overflow bug in IE 5 & 6 ?>
                  <?php print $below_right; ?>
                </div></div></div>
              <?php endif; ?>

            </div>
          <?php endif; ?>

          <?php print $feed_icons ?>

        </div>

      </div></div></div></div>

      <?php if ($left): ?>
        <div id="sidebar-left" class="sidebar"><div id="sidebar-left-inner">
          <?php print $left; ?>
        </div></div>
      <?php endif; ?>

      <?php if ($sidebar_left2): ?>
        <div id="sidebar-left2" class="sidebar"><div id="sidebar-left2-inner"><div id="sidebar-left2-inner2">
          <?php print $sidebar_left2; ?>
        </div></div></div>
      <?php endif; ?>

      <?php if ($right): ?>
        <div id="sidebar-right" class="sidebar"><div id="sidebar-right-inner">
          <?php print $right; ?>
        </div></div>
      <?php endif; ?>

      <?php if ($sidebar_right2): ?>
        <div id="sidebar-right2" class="sidebar"><div id="sidebar-right2-inner"><div id="sidebar-right2-inner2">
          <?php print $sidebar_right2; ?>
        </div></div></div>
      <?php endif; ?>

    </div></div></div></div>

    <?php if ($footer_col13 || $footer_col23 || $footer_col33): ?>
      <div class="clear-this">

        <?php if ($footer_col13): ?>
          <div class="col13"><div class="col13-inner"><div class="col13-inner2">
          <?php // col13-inner because of box model bug in IE 5. col13-inner2 because of overflow bug in IE 5 & 6 ?>
            <?php print $footer_col13; ?>
          </div></div></div>
        <?php endif; ?>

        <?php if ($footer_col23): ?>
          <div class="col23"><div class="col23-inner"><div class="col23-inner2">
          <?php // col23-inner because of box model bug in IE 5. col23-inner2 because of overflow bug in IE 5 & 6 ?>
            <?php print $footer_col23; ?>
          </div></div></div>
        <?php endif; ?>

        <?php if ($footer_col33): ?>
          <div class="col33"><div class="col33-inner"><div class="col33-inner2">
          <?php // col33-inner because of box model bug in IE 5. col33-inner2 because of overflow bug in IE 5 & 6 ?>
            <?php print $footer_col33; ?>
          </div></div></div>
        <?php endif; ?>

      </div>
    <?php endif; ?>

    <?php if ($footer_left || $footer_right): ?>
      <div class="clear-this">

        <?php if ($footer_left): ?>
          <div class="col-left"><div class="col-left-inner"><div class="col-left-inner2">
          <?php // left-inner because of box model bug in IE 5. left-inner2 because of overflow bug in IE 5 & 6 ?>
            <?php print $footer_left; ?>
          </div></div></div>
        <?php endif; ?>

        <?php if ($footer_right): ?>
          <div class="col-right"><div class="col-right-inner"><div class="col-right-inner2">
          <?php // right-inner because of box model bug in IE 5. right-inner2 because of overflow bug in IE 5 & 6 ?>
            <?php print $footer_right; ?>
          </div></div></div>
        <?php endif; ?>

      </div>
    <?php endif; ?>

    <div id="footer"><div id="footer-inner">
      <?php echo $footer_message . $footer ?><br/>
      <a href="http://www.fireandknowledge.org">Theme</a> <a href="http://www.avioso.com">port</a> sponsored by Duplika <a href="http://www.duplika.com">Web Hosting</a>.
    </div></div>

    <?php print $closure ?>

  </div>

  <?php if ($bottom_col14 || $bottom_col24 || $bottom_col34 || $bottom_col44 || $bottom_col13 || $bottom_col23 || $bottom_col33 || $bottom_left || $bottom_right || $page_bottom): ?>
    <div id="lower-regions">

      <?php if ($bottom_col14 || $bottom_col24 || $bottom_col34 || $bottom_col44): ?>
        <div class="clear-this">

          <?php if ($bottom_col14): ?>
            <div class="col14"><div class="col14-inner"><div class="col14-inner2">
            <?php // col14-inner because of box model bug in IE 5. col14-inner2 because of overflow bug in IE 5 & 6 ?>
              <?php print $bottom_col14; ?>
            </div></div></div>
          <?php endif; ?>

          <?php if ($bottom_col24): ?>
            <div class="col24"><div class="col24-inner"><div class="col24-inner2">
            <?php // col24-inner because of box model bug in IE 5. col24-inner2 because of overflow bug in IE 5 & 6 ?>
              <?php print $bottom_col24; ?>
            </div></div></div>
          <?php endif; ?>

          <?php if ($bottom_col34): ?>
            <div class="col34"><div class="col34-inner"><div class="col34-inner2">
            <?php // col34-inner because of box model bug in IE 5. col34-inner2 because of overflow bug in IE 5 & 6 ?>
              <?php print $bottom_col34; ?>
            </div></div></div>
          <?php endif; ?>

          <?php if ($bottom_col44): ?>
            <div class="col44"><div class="col44-inner"><div class="col44-inner2">
            <?php // col44-inner because of box model bug in IE 5. col44-inner2 because of overflow bug in IE 5 & 6 ?>
              <?php print $bottom_col44; ?>
            </div></div></div>
          <?php endif; ?>

        </div>
      <?php endif; ?>

      <?php if ($bottom_col13 || $bottom_col23 || $bottom_col33): ?>
        <div class="clear-this">

          <?php if ($bottom_col13): ?>
            <div class="col13"><div class="col13-inner"><div class="col13-inner2">
            <?php // col13-inner because of box model bug in IE 5. col13-inner2 because of overflow bug in IE 5 & 6 ?>
              <?php print $bottom_col13; ?>
            </div></div></div>
          <?php endif; ?>

          <?php if ($bottom_col23): ?>
            <div class="col23"><div class="col23-inner"><div class="col23-inner2">
            <?php // col23-inner because of box model bug in IE 5. col23-inner2 because of overflow bug in IE 5 & 6 ?>
              <?php print $bottom_col23; ?>
            </div></div></div>
          <?php endif; ?>

          <?php if ($bottom_col33): ?>
            <div class="col33"><div class="col33-inner"><div class="col33-inner2">
            <?php // col33-inner because of box model bug in IE 5. col33-inner2 because of overflow bug in IE 5 & 6 ?>
              <?php print $bottom_col33; ?>
            </div></div></div>
          <?php endif; ?>

        </div>
      <?php endif; ?>

      <?php if ($bottom_left || $bottom_right): ?>
        <div class="clear-this">

          <?php if ($bottom_left): ?>
            <div class="col-left"><div class="col-left-inner"><div class="col-left-inner2">
            <?php // left-inner because of box model bug in IE 5. left-inner2 because of overflow bug in IE 5 & 6 ?>
              <?php print $bottom_left; ?>
            </div></div></div>
          <?php endif; ?>

          <?php if ($bottom_right): ?>
            <div class="col-right"><div class="col-right-inner"><div class="col-right-inner2">
            <?php // right-inner because of box model bug in IE 5. right-inner2 because of overflow bug in IE 5 & 6 ?>
              <?php print $bottom_right; ?>
            </div></div></div>
          <?php endif; ?>

        </div>
      <?php endif; ?>

      <?php if ($page_bottom): ?>
        <div id="page-bottom">
          <?php print $page_bottom; ?>
        </div>
      <?php endif; ?>

    </div>
  <?php endif; ?>

</div></div></div>
</body>
</html>
