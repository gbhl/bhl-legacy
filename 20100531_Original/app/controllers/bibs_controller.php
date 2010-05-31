<?php

class BibsController extends AppController {
        var $name = 'Bibs'; var $components = array ('Pagination', 'Filter','Report');
        var $helpers = array('Html','Pagination','Filter','Matchlinker','Bidbutton' ); // Added 'SerialsMatchLinker'
        var $uses = array('Bib','Bid','Status','User','Holding');


     function view($id = null) {
        $this->Bib->id = $id;
        $this->set('bib', $this->Bib->read());
       // $this->set('bids', $this->Bid->findAll(array('bib_id'
       // =>'$this->Bib->id')));
    }

    /* - KILLED BY BERNARD...
     function add() {
        if (!empty($this->data)) {
            if ($this->bib->save($this->data)) {
                $this->flash('Your post has been saved.','/bibs/');
            }
        }
    }
    */

        function dedupselect() {
                // Note, any changes here need to be replicated in index function, and vice-versa
                // Totally ripped from http://mho.ath.cx/~cake/exams/filter/
            $this->Bib->recursive = 1;
              $cond = 'depreciated is NULL';
        /* Setup filters */
            $this->Filter->init($this, 'Bib');

            $this->Filter->setFilter(aa('id',
            'Record ID'), NULL, a('=','!=', '>', '<') );

            $this->Filter->setFilter(aa('title', 'Title'), NULL, a(
            '~','^','!~', '='));

            $this->Filter->setFilter(aa('abbrev_title', 'Abbreviated title'), NULL, a(
            '~','^','!~', '='));


            $this->Filter->setFilter(aa('pub',
            'Publisher'), NULL, a( '~','^','!~', '='));

            $this->Filter->setFilter(aa('match_basis', 'Match method (022, OCLC, TITLE, NO MATCH)'), NULL,
            a('=', '~'));

            $this->Filter->setFilter(aa('places',
            'Place'), NULL, a( '~','^','!~', '='));

            $this->Filter->setFilter(aa('subjects',
            'Subject'), NULL, a( '~','^','!~', '='));



            $this->Filter->filter($f, $cond); $this->set('filters', $f);

            /* Setup pagination */
            $this->Pagination->controller = &$this;
            $this->Pagination->show = 30;
            $this->Pagination->init(
                $cond, 'Bib', NULL, array('id', 'title', 'pub', 'abbrev_title', 'match_basis', 'places', 'subjects'), 0
            );

            $this->set('Bibs', $this->Bib->findAll(
                $cond, NULL, $this->Pagination->order, $this->Pagination->show,
                $this->Pagination->page
            ));

        }

        function dedup($id = null) {
        // Inital call to set up both records
         $this->Bib->id = $this->params['form']['id1'];
         $this->set('bib1',$this->Bib->read());
         $this->Bib->id = $this->params['form']['id2'];
         $this->set('bib2', $this->Bib->read());
        }

        function dedup2($id=null) {

            // Grab our two bib id's from form parameters....
            $idtokeep = $this->params['form']['idtokeep'];
            //$this->set('idtokeep',$idtokeep);
            $idtodel =  $this->params['form']['idtodel'];
            //$this->set('idtodel',$idtodel);
            // Update holdings and bids where id = idtodel set all fkeys to idtokeep

             // Get each bid where bib_id = $idtodel and change the fkey
            $bidstochange = $this->Bid->findall(array('bib_id'=>$idtodel));
            foreach ($bidstochange as $bidtochange)
                {
                $bidtochange['Bid']['bib_id'] = $idtokeep;
                $this->Bid->save($bidtochange['Bid']);
                }

             // repeat for holdings
            $holdingstochange = $this->Holding->findall(array('bib_id'=>$idtodel));
            foreach ($holdingstochange as $holdingtochange )
                {
                $holdingtochange['Holding']['bib_id'] = $idtokeep;
                $this->Holding->save($holdingtochange['Holding']);
                }

            //-----------------------
             // Code to process 'flat' matches field in current bib model - REMOVE THIS ONCE ALL MATCHES ARE HELD IN THE HOLDINGS TABLE
             //First, process on bib to depreciate...
               $this->Bib->id = $idtodel;
               $grabbedmatch = $this->Bib->field('matches');
               $this->set('grabbedmatch',$grabbedmatch);


               // Flag bibtodel as depreciated, rather than delete...
               //This following line will need to stay even if 'flat' code is removed...
               $this->Bib->saveField('depreciated',1);

              // Switch to bib to keep
              $this->Bib->id = $idtokeep;
              $newmatch = $this->Bib->field('matches'). " " . $grabbedmatch;
              $this->Bib->saveField('matches',$newmatch);

              $newmatch ='';
              $grabbedmatch = '';
            // ---------------------------End flat matches code

            // Delete from bis where id = idtodel - not used currently...
             //$this->Bib->delete($idtodel);

          // Flash - record has been deduped - pass to view for record to keep!!
          $this->flash('Records has been updated de-duplicated (Click here to continue)',"/bibs/view/$idtokeep");
        }

//**********************

        function index() {
                // Totally ripped from http://mho.ath.cx/~cake/exams/filter/
            // BS recursive = 1 seems to indicate it gets related records by foreign key too
            $this->Bib->recursive = 1;
            //var_dump($this->Bib->Field('title'));
           // EC Amendment Condition to filter depreciated material. has been added to filter component (components/filter.php)


        /* Setup filters */
            $this->Filter->init($this, 'Bib');

            $this->Filter->setFilter(aa('id',
            'Record ID'), NULL, a('=','!=', '>', '<') );

            $this->Filter->setFilter(aa('title', 'Title'), NULL, a(
            '~','^','!~', '='));

            $this->Filter->setFilter(aa('abbrev_title', 'Abbreviated title'), NULL, a(
            '~','^','!~', '='));


            $this->Filter->setFilter(aa('pub',
            'Publisher'), NULL, a( '~','^','!~', '='));

            $this->Filter->setFilter(aa('match_basis', 'Match method (022, OCLC, TITLE, NO MATCH)'), NULL,
            a('=', '~'));

            $this->Filter->setFilter(aa('places',
            'Place'), NULL, a( '~','^','!~', '='));

            $this->Filter->setFilter(aa('subjects',
            'Subject'), NULL, a( '~','^','!~', '='));



            $this->Filter->filter($f, $cond); $this->set('filters', $f);





            /* Setup pagination */
            $this->Pagination->controller = &$this;
            $this->Pagination->show = 30;

            $this->Pagination->init(
                $cond, 'Bib', NULL, array('id', 'title', 'pub', 'abbrev_title', 'match_basis', 'places', 'subjects'), 0
            );
                            //'depreciated is NULL'
            $this->set('Bibs', $this->Bib->findAll(
                $cond,'',$this->Pagination->order, $this->Pagination->show,
                $this->Pagination->page
            ));

            //var_dump($this->Bib->holdings);
        }


//**********************



         function createReport()
    {
        if (!empty($this->data))
        {
            //Determine if user is pulling existing report or deleting report
            if(isset($this->params['form']['existing']))
            {
                if($this->params['form']['existing']=='Pull')
                {
                    //Pull report
                    $this->Report->pull_report($this->data['Misc']['saved_reports']);
                }
                else if($this->params['form']['existing']=='Delete')
                {
                    //Delete report
                    $this->Report->delete_report($this->data['Misc']['saved_reports']);

                    //Return user to form
                    $this->flash('Your report has been deleted.','/'.$this->name.'/'.$this->action.'');
                }
            }
            else
            {
                //Filter out fields
                $this->Report->init_display($this->data);

                //Set sort parameter
                if(!isset($this->params['form']['order_by_primary'])) { $this->params['form']['order_by_primary']=NULL; }
                if(!isset($this->params['form']['order_by_secondary'])) { $this->params['form']['order_by_secondary']=NULL; }
                $this->Report->get_order_by($this->params['form']['order_by_primary'], $this->params['form']['order_by_secondary']);

                //Store report name
                if(!empty($this->params['form']['report_name']))
                {
                    $this->Report->save_report_name($this->params['form']['report_name']);
                }

                //Store report if save was executed
                if($this->params['form']['submit']=='Create And Save Report')
                {
                    if(empty($this->params['form']['report_name']))
                    {
                        //Return user to form
                        $this->flash('Must enter a report name when saving.','/'.$this->name.'/'.$this->action.'');
                    }
                    else
                    {
                        $this->Report->save_report();
                    }
                }
            }

            //Set report fields
            $this->set('report_fields', $this->Report->report_fields);

            //Set report name
            $this->set('report_name', $this->Report->report_name);

            //Allow search to go 2 associations deep
            $this->{$this->modelClass}->recursive = 2;

            //Set report data
            $this->set('report_data', $this->{$this->modelClass}->findAll(NULL,NULL,$this->Report->order_by));
        }
        else
        {
            //Setup options for report component
            /*
                You can setup a level two association by doing the following:
                "VehicleDriver"=>"Employee" ie $models = Array ("Vehicle", "VehicleDriver"=>"Employee");
                Please note that all fields within a level two association cannot be sorted.
            */
            $models =    Array ('Bib');

            //Set array of fields
            $this->set('report_form', $this->Report->init_form($models));

            //Set current controller
            $this->set('cur_controller', $this->name);

            //Pull all existing reports
            $this->set('existing_reports', $this->Report->existing_reports());
        }
    }


        function edit($id = null) {
                if (empty($this->data)) {
                        $this->Bib->id = $id;
                        $this->data = $this->Bib->read();
                        $this->set('bib',$this->Bib->read());
                } else {
                        if ($this->Bib->save($this->data['bib'])) {
                                $this->flash('Your post has been
                                updated (Click here to continue)','/bibs');
                        }
                }
        }




}

?>