<?php
class Bid extends AppModel
{
var $name = 'Bid';
var $recursive = 2;
var $belongsTo = array(
							'Match' =>array('className'  => 'Match',
                                 'conditions' => '',
                                 'order'      => '',
                                 'foreignKey' => 'title_id'
                           ),

                           'User' =>array('className'  => 'User',
                                 'conditions' => '',
                                 'order'      => '',
                                 'foreignKey' => 'user_id'
                           ),

                           'Status' =>array('className'  => 'Status',
                                 'conditions' => '',
                                 'order'      => '',
                                 'foreignKey' => 'status_id'));


}

?>