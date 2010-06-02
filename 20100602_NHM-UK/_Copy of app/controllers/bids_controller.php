<?php
class BidsController extends AppController
{
    var $name = 'Bids';
    var $components = array ('Pagination', 'Filter', 'othAuth'); // Added
    var $helpers = array('Html','Pagination', 'Filter'); // Added
    //var $scaffold;
    var $uses = array('Bid','Match','Status');
    var $bids_exist;


    function bidall()
    {
		if (!empty($this->data))
        	{
	           $this->Bid->save($this->data);
	           $this->flash('Your Bid has been saved  <br/> (Click here to continue)','/matches/');
    		}
    } // End function



        function bidpartial($id = null)
        {
        $this->set('bid_so_far', $this->data['Bid']);
        }

    function edit($id = null)
	{
            $this->set('Statuses', array(1=>'Started',2=>'Complete',3=>'On hold'));
		if (empty($this->data))
		{
			$this->Bid->id = $id;
			$this->data = $this->Bid->read();
		}
		else
		{
			if ($this->Bid->save($this->data['Bid']))
			{
				$this->flash('Your bid has been updated.',"/matches");
			}
		}
	}
        
	function index()
	{     		// Totally ripped from http://mho.ath.cx/~cake/exams/filter/
  		 $this->Bid->recursive = 2;

        /* Setup filters */
        $this->Filter->init($this);
        $this->Filter->setFilter(aa('id', 'Record key'), NULL, a('=','!=')) ;
        $this->Filter->setFilter(aa('start_date', 'Start Date'), NULL, a('=','!=','<','<=','>','>=')) ;
        $this->Filter->setFilter(aa('end_date', 'End Date'), NULL, a('=','!=','<','<=','>','>=')) ;
        $this->Filter->filter($f, $cond);
        $this->set('filters', $f);

        /* Setup pagination */
        $this->Pagination->controller = &$this;
        $this->Pagination->show = 30;
        $this->Pagination->init(
            $cond,
            'Bid',
            NULL,
            array('id', 'title_id', 'user_id', 'partial','start_date', 'end_date', 'status_id','notes'),
            0
        );

        $this->set('Bids', $this->Bid->findAll(
            $cond,
            NULL,
            $this->Pagination->order,
            $this->Pagination->show,
            $this->Pagination->page
        ));
	}

     function rss()
    {
        $this->layout = 'xml';
        $this->set('Bids', $this->Bid->findAll('', null, '', 15));
    }


  	function delete($id)
	{
    $this->Bid->del($id);
    $this->flash('The bid with id: '.$id.' has been deleted. (Click to continue)', '/matches');
  	}


}
 ?>