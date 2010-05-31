<?php


class matchlinkerhelper extends Helper

{
  var $html;

function generate_opac_links($ctrl002)
			 {
			    #replace all tabs with spaces in ctrl002 first
				    #$ctrl002 = str_replace("\t"," ", $ctrl002);

					# split into words delimiting by space
					$ctrls_002 = split(" ",$ctrl002);
					# echo them all using direct url syntax as appropriate
                    $html =''; // String to return
						// Initalise arrays for each institution
						$nhm_bibs= array();
						$sil_bibs = array();

						// Dumping array for patches
						$ctrl_matches = array();

						// Split horrible multi-value database field on spaces into seperate control numbers
						$ctrls_002 = split(" ",$ctrl002);

						// Iterate through ctrl numbers...
							foreach ($ctrls_002 as $ctrl_match)
							{
							    // Check to see if it belongs to the Smithsonian...
							 	if (preg_match("/\d*SIL\d*/", $ctrl_match, $ctrl_matches))
							    {
							  	//Spilt on characters SIL
							  	$sil_split = preg_split("/SIL/", $ctrl_match);

								// Take second element as bib match, & push to Smithsonian controls array
							    array_push($sil_bibs, $sil_split[1]);



								$html .= "Smithsonian record: <a class='actionbut' target='_blank' href=' ";

				                $html .= "http://siris-libraries.si.edu/ipac20/ipac.jsp?&menu=search&aspect=power&npp=20&ipp=20&profile=dial&ri=&oper=and&aspect=power&index=BIB&term=" . rtrim($sil_split[1]);
				                $html .=  "'>";
							    $html .=  "$sil_split[1]";
				  				$html .=  "</a>";

				                $html .=  "<BR/>";


							    }

								// Check to see if it belongs to the NHM...
								elseif  (preg_match ("/\d*NHM\d*/", $ctrl_match, $ctrl_matches))
								{
								//Spilt on characters "_(Sirsi)_"
							    $nhm_split = preg_split("/\(Sirsi\)/", $ctrl_match);

								// Take second element from matches & strip element of underscores
								$nhm_bib = preg_replace("/_/","",$nhm_split[1]);

							    // push onto NHM array
							    array_push($nhm_bibs, $nhm_bib);


							    $html .= "NHM UK record: <a class='actionbut' target='_blank' href=' ";

				                $html .=  "http://unicorn.nhm.ac.uk/uhtbin/cgisirsi/x/0/5?searchdata1=" . rtrim($nhm_bib)  . "&srchfield1=CKEY";
				                $html .=  "'>";
							    $html .=  "$nhm_bib";
				  				$html .=  "</a>";

				                $html .=  "<BR>";

							    }

							   // Add additional clauses for additional institutions here

							} // End foreach loop
                 return $html;
 			 } // End function / method
} // End class

?>
