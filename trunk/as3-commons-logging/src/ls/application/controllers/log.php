<?php

class Log extends CI_Controller {
	
	public function __construct()
	{
	 	parent::__construct();
	 	$this->load->model('log_model');
	 	$this->config->load('log_settings');
	}	

	public function show()
	{
		
	}

	public function exec()
	{

		if( function_exists('getallheaders') )
		{
			$headers = getallheaders();
		}
		else if( function_exists('apache_request_headers') )
		{
			$headers = apache_request_headers();
		}
		else if( function_exists('nsapi_request_headers') )
		{
			$headers = nsapi_request_headers();
		}
		if( isset($headers) ) 
		{
			// Gather available session information from the header
			$lsid = isset($headers['lsid']) ? $headers['lsid'] : FALSE;
			$sessionType = isset($headers['sessionType']) ? $headers['sessionType'] : FALSE;

			// Parse all the input
			$input = $this->input->post('s');
			$statements = array();
			$start = 0;
			while($start < strlen($input)) {
				if( $start != 0 ) {
					$input = substr($input, $start);
				}
				$end = strpos($input,';');
				$level = hexdec(substr($input, 0, $end));
				$input = substr($input, $end+1);
				$end = strpos($input,';');
				$no = hexdec(substr($input, 0, $end));
				$input = substr($input, $end+1);
				$end = strpos($input,';');
				$nameLen = hexdec(substr($input, 0, $end));
				$input = substr($input, $end+1);
				$name = substr($input, 0, $nameLen);
				$input = substr($input, $nameLen+1);
				$end = strpos($input,';');
				$personLen = hexdec(substr($input, 0, $end));
				$input = substr($input, $end+1);
				$person = substr($input, 0, $personLen);
				$input = substr($input, $personLen+1);
				$end = strpos($input, ';');
				$messageLen = hexdec(substr($input, 0, $end));
				$input = substr($input, $end+1);
				$message = substr($input, 0, $messageLen);
				$input = substr($input, $messageLen+1);
				$end = strpos($input, ';');
				$timeStamp = hexdec(substr($input, 0, $end));
				$input = substr($input, $end+1);
				$end = strpos($input, ';');
				$parameterLen = hexdec(substr($input, 0, $end));
				if($parameterLen > 0) {
					$input = substr($input, $end+1);
					$parameter = substr($input, 0, $parameterLen);
					$start = $parameterLen+1;
				} else {	
					$start = $end+2;
					$parameter = '';
				}
				// Put the statement in a acceptable array
				$statement = array(
					'no' => $no,
					'name' => $name,
					'time_stamp' => $timeStamp,
					'person' => $person,
					'level' => $level,
					'message' => $message,
					'parameters' => $parameter,
				);	
				$statements[] = $statement;			
			}
			
			// Store the statements
			$lsid = $this->log_model->store( $lsid, $sessionType, $statements);

			// Return the used lsid so the next request can use it again (may start with error)
			if( substr($lsid, 0, 5) == 'ERROR' ) {
				show_error($lsid);
			} else {
				// Return the session id so the client can refer future statements to a session!
				exit($lsid);
			}
		}
		else
		{
			show_error('Server does not support headers, this feature is required for SL.');
		}
	}
}