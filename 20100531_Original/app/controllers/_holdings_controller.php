<?php
class HoldingsController extends AppController
{
  var $name = 'Holdings';
    var $components = array ('Pagination', 'Filter', 'othAuth'); // Added
    var $helpers = array('Html','Pagination', 'Filter'); // Added
    //var $scaffold;
    var $uses = array('Holding','Bid','Holding','Status');

     function edit($id = null)
	{

		if (empty($this->data))
		{
			$this->Holding->id = $id;
			$this->data = $this->Holding->read();
                        $this->set('bid',$this->Holding->read());
		}
		else
		{
			if ($this->Holding->save($this->data['Bid']))
			{
				$this->flash('Your Holdings have been updated.',"/bibs");
			}
		}
	}

  	function delete($id)
	{
        $this->Holding->del($id);
        $this->flash('The holding with id: '.$id.' has been deleted. (Click to continue)', '/bibs/');
  	}

//**********************

        function index() {
                // Totally ripped from http://mho.ath.cx/~cake/exams/filter/
            // BS recursive = 1 seems to indicate it gets related records by foreign key too
            $this->Holding->recursive = 1;
            var_dump($this->Holding);
           // EC Amendment Condition to filter depreciated material. has been added to filter component (components/filter.php)
            // BS temporarily turned off


         // BS added to allow us to display matching places from brief results page too.
         //$holdings = $Holdings['Holding'];


        /* Setup filters */
            $this->Filter->init($this);

            $this->Filter->setFilter(aa('id',
            'Record ID'), NULL, a('=','!=', '>', '<') );

            $this->Filter->setFilter(aa('subject', 'Subject'), NULL, a(
            '~','^','!~', '='));

            $this->Filter->setFilter(aa('e_856', 'e-access'), NULL, a(
            '~','^','!~', '='));


            $this->Filter->setFilter(aa('place',
            'Place'), NULL, a( '~','^','!~', '='));

            $this->Filter->setFilter(aa('match_basis', 'Match method (022, 245, TITLE, NO MATCH)'), NULL,
            a('=', '~'));


            $this->Filter->filter($f, $cond); $this->set('filters', $f);


            /* Setup pagination */
            $this->Pagination->controller = &$this; $this->Pagination->show = 30;
            $this->Pagination->init(
                $cond, 'Holding', NULL, array('id', 'subject', 'e_856', 'place', 'match_basis'), 0
            );
                            //'depreciated is NULL'
            $this->set('Holdings', $this->Holding->findAll(
                $cond,'',$this->Pagination->order, $this->Pagination->show,
                $this->Pagination->page
            ));
        }


//**********************




}

?>