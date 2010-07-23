<?php
// $Id: biblio_handler_citation.inc,v 1.1.2.5.2.4 2010/03/26 13:16:04 rjerome Exp $
class biblio_handler_citation extends views_handler_field {
  var $author_options;
  var $biblio_base;

  function init(&$view, $options) {
    parent::init($view, $options);
    $this->additional_fields['vid'] = array('table' => 'biblio', 'field' => 'vid');

  }
  function query() {
    $this->add_additional_fields();
    $this->field_alias = $this->aliases['vid'];
    // add the biblio_type field as tid
  }
  function option_definition() {
    $options = parent::option_definition();
    $options['style_name'] = array('default' => biblio_get_style());
    return $options;
  }
  function options_form(&$form, &$form_state) {
    parent::options_form($form, $form_state);
    module_load_include('inc','biblio','biblio.admin');
    $form['style_name'] = array(
      '#type' => 'radios',
      '#title' => t('Style'),
      '#default_value' => $this->options['style_name'],
      '#options' => _biblio_admin_get_styles(),
      '#description' => t('Define the layout of author lists.')
    );
  }

  function render($values) {
    module_load_include('inc', 'biblio', 'styles/biblio_style_'.$this->options['style_name']);
    if (empty($this->author_options)) {
      $author_options_func = 'biblio_style_'.$this->options['style_name'].'_author_options';
      $this->author_options = $author_options_func();
    }

    if (empty($this->biblio_base)) {
      $this->biblio_base = variable_get('biblio_base', 'biblio');
    }

    $item = node_load($values->nid);
    if ($item->type != 'biblio') return;

    if (isset($item->biblio_year)) $item->biblio_year = _biblio_text_year($item->biblio_year);
    if (variable_get('biblio_hide_bibtex_braces', 0)) {
      $item->title = biblio_remove_brace($item->title);
    }

    return theme('biblio_entry', $item, $this->biblio_base, $this->options['style_name'], $inline);
  }

}