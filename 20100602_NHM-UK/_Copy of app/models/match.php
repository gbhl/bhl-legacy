<?php

class Match extends AppModel
{
    var $name = 'Match';

   var $hasMany = array(
							'Bid' =>array('className'  => 'Bid',
                                 'conditions' => '',
                                 'order'      => '',
                                 'foreignKey' => 'title_id'
                           ));


				      var $validate = array(

				        'title'  => VALID_NOT_EMPTY,
				        '001'   => VALID_NOT_EMPTY,
				        '002'   => VALID_NOT_EMPTY,
				        '008'   => VALID_NOT_EMPTY,
				        '022'   => VALID_NOT_EMPTY,
				        'pub'   => VALID_NOT_EMPTY,
				    );

var  $recursive = 2;
}

?>