<?php

class MatchesController extends AppController
{
    var $name = 'Matches';
    var $components = array ('Pagination', 'Filter'); // Added
	var $helpers = array('Html','Pagination', 'Filter','Matchlinker','Bidbutton'  ); // Added       'SerialsMatchLinker'

   	//var $scaffold;
  	 var $uses = array('Match','Bid','Status','User');


        function view($id = null)
    {

        $this->Match->id = $id;
        $this->set('match', $this->Match->read());
        $this->set('bids', $this->Bid->findAll(array('title_id' =>'$this->Match->id')));

    }

     function add()
    {
        if (!empty($this->data))
        {
            if ($this->Match->save($this->data))
            {
                $this->flash('Your post has been saved.','/matches');
            }
        }
    }

   function browseby()
	{
     //$alpha = $this->data['alpha'];
      $alpha ='a';


           /* Setup pagination */
        $this->Pagination->controller = &$this;
        $this->Pagination->show = 30;
        $this->Pagination->init(
            '',
            'Match',
            NULL,
            array('id', 'title', 'pub', 'matches'),
            0
        );

        $this->set('Matches', $this->Match->findAllByTitle('$alpha'),
           '',
            NULL,
            $this->Pagination->order,
            $this->Pagination->show,
            $this->Pagination->page);


	}



	function index()
	{
		// Totally ripped from http://mho.ath.cx/~cake/exams/filter/
  		 $this->Match->recursive = 1;

        /* Setup filters */
        $this->Filter->init($this);
        $this->Filter->setFilter(aa('id', 'Record key'), NULL, a('=','!=') );
        $this->Filter->setFilter(aa('title', 'Title'), NULL, a( '~','^','!~', '='));
        $this->Filter->setFilter(aa('pub', 'Publisher'), NULL, a( '~','^','!~', '='));
        $this->Filter->setFilter(aa('place', 'Holding institution code'), NULL, a('=', '^', '~', '!~'));
        $this->Filter->setFilter(aa('held_by_num', 'Number of sites held by'), NULL, a('=', '<', '>'));
        $this->Filter->setFilter(aa('match_method', 'Match method'), NULL, a('=', '~'));

        $this->Filter->filter($f, $cond);
        $this->set('filters', $f);

        /* Setup pagination */
        $this->Pagination->controller = &$this;
        $this->Pagination->show = 30;
        $this->Pagination->init(
            $cond,
            'Match',
            NULL,
            array('id', 'title', 'pub', 'matches'),
            0
        );

        $this->set('Matches', $this->Match->findAll(
            $cond,
            NULL,
            $this->Pagination->order,
            $this->Pagination->show,
            $this->Pagination->page
        ));

	}





	function edit($id = null)
	{
		if (empty($this->data))
		{
			$this->Match->id = $id;
			$this->data = $this->Match->read();
		}
		else
		{
			if ($this->Match->save($this->data['Match']))
			{
				$this->flash('Your post has been updated.','/matches');
			}
		}
	}



}

?>