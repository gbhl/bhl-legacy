<?php
//$Id: apachesolr_biblio.admin.inc,v 1.2 2009/11/07 04:02:13 davidlesieur Exp $
function apachesolr_biblio_fields_form($form_state) {
  $defaults = apachesolr_biblio_get_fields();
  $form['contributors'] = array(
    '#type' => 'checkbox',
    '#title' => t('Contributors'),
    '#description' => t('Should authors be indexed? This feature is either on or off. No control is given to index some author types and not others.'),
    '#default_value' => $defaults['contributors'],
  );
  $form['biblio_type'] = array(
    '#type' => 'checkbox',
    '#title' => t('Publication Types'),
    '#description' => t('Should publication types be indexed? This feature is either on or off.'),
    '#default_value' => $defaults['biblio_type'],
  );

  $fields = apachesolr_biblio_get_raw_fields();
  $form['configured_flds'] = array('#tree' => 1);
  foreach ($fields as $key => $fld) {
    // If a string contains the word "author", it's
    // a multiple string that gets packed into "contributors".
    // These get handled all at once, basically, so we ignore them.
    if (strpos($fld['name'], 'author')) continue;

    $form['configured_flds'][$key]['display_name'] = array(
      '#type' => 'item',
      '#value' => $fld['name'],
      '#weight' => $fld['weight'],
    );
    $form['configured_flds'][$key]['name'] = array(
      '#type' => 'value',
      '#value' => $fld['name'],
    );
    $form['configured_flds'][$key]['title'] = array(
      '#type' => 'item',
      '#value' => $fld['title'],
      '#weight' => $fld['weight'],
    );
    $options = array();
    if (isset($defaults[$key]['indexed']) && $defaults[$key]['indexed']) {
      $options[] = 'indexed';
    }
    $form['configured_flds'][$key]['checkboxes'] = array(
      '#type' => 'checkboxes',
      '#options' => array('indexed' => ''),
      '#default_value' => $options,
      '#weight' => $fld['weight'],
    );
    $form['configured_flds'][$key]['index_type'] = array(
      '#type' => 'select',
      '#options' => array('string' => t('String'), 'date' => t('Date')),
      '#multiple' => FALSE,
      '#default_value' => (isset($defaults[$key]['index_type']) ? $defaults[$key]['index_type'] : 'string'),
    );
//      '#options' => array('string' => t('String'), 'date' => t('Date')),
//      '#default_value' => (isset($defaults[$key]['index_type']) ? $defaults[$key]['index_type'] : 'string'),
//  DLH 20100823 Adding field setting, Changing to be more accurate to how this functions, it's not a datatype, it's a toggle for multiple or single 
    $form['configured_flds'][$key]['multiple'] = array(
      '#type' => 'select',
      '#options' => array('0' => t('Single'), '1' => t('Multiple')),
      '#default_value' => $defaults[$key]['multiple']
    );
  }

  $form['submit'] = array(
    '#type' => 'submit',
    '#value' => t('Save')
  );

  return $form;
}

function theme_apachesolr_biblio_fields_form($form) {
  $output  = drupal_render($form['contributors']);
  $output .= drupal_render($form['biblio_type']);

  $conf_table = array();
  foreach (element_children($form['configured_flds']) as $fld) {
    $form['configured_flds'][$fld]['weight']['#attributes']['class'] = 'weight';
    $conf_row = array();
    $conf_row[] = array('data' => drupal_render($form['configured_flds'][$fld]['display_name']));
    $conf_row[] = array('data' => drupal_render($form['configured_flds'][$fld]['title']));
    foreach (element_children($form['configured_flds'][$fld]['checkboxes']) as $oid) {
      if (is_array($form['configured_flds'][$fld]['checkboxes'])) {
        $conf_row[] = array(
          'data' => drupal_render($form['configured_flds'][$fld]['checkboxes'][$oid]),
          'title' => $oid);
      }
    }
    $conf_row[] = array('data' => drupal_render($form['configured_flds'][$fld]['index_type']));
    $conf_row[] = array('data' => drupal_render($form['configured_flds'][$fld]['multiple']));
    $conf_table[] = array('data' => $conf_row);
  }

  $header = array(t('Field Name'), t('Title'), t('Index'), t('Data type'), t('Multiple'));

  $output .= theme('table', $header, $conf_table, array('id' => 'field-table'));
  $output .= drupal_render($form['submit']);
  $output .= drupal_render($form);
  return $output;
}

function apachesolr_biblio_fields_form_submit($form, $form_state) {
  db_query('DELETE FROM {apachesolr_biblio_fields');
  foreach($form_state['values']['configured_flds'] as $fid => $field) {
    $record = new stdClass();
    $record->fid = $fid;
    $record->name = $field['name'];
    $record->index_type = $field['index_type'];
    $record->indexed = ($field['checkboxes']['indexed'] == '0' ? 0 : 1);
    $record->multiple = ($field['multiple'] == '1' ? 1 : 0);
    drupal_write_record('apachesolr_biblio_fields', $record);
    variable_set('apachesolr_biblio_index_authors', $form_state['values']['contributors']);
    variable_set('apachesolr_biblio_index_biblio_type', $form_state['values']['biblio_type']);
  }
}
