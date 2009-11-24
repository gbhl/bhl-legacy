About
-----

jQuery Greybox Module

This module enables the use of greybox which places content pages above your current page, not within. This frees you from the constraints of the layout, particularly column widths.

This module will include the greybox CSS and JS files in your Drupal Installation without the need to edit the theme. The module comes with a configurable greybox class, window width and height options.

Greybox libraries and integration module licensed under the GNU/GPL License.


Install
-----

1. Copy greybox folder to modules directory.
2. Enable the module at admin/build/modules.
3. Optionally, set the configuration at admin/settings/greybox.


Usage
-----

Add class="greybox" (or as specified in settings) attribute to any link tag to activate the greybox for. For example:
<a href="http://google.com/" class="greybox" title="my caption">link #1</a>

Use rel="WIDTHxHEIGHT" attribute to explicitly specify the greybox window dimensions for that link. For example:
<a href="http://google.com/" class="greybox" title="my caption" rel="350x200">link #2</a>


Maintainer
-----

Gurpartap Singh <http://drupal.org/user/41470/contact>