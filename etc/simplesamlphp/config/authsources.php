<?php

$config = array(

    // This is a authentication source which handles admin authentication.
    'admin' => array(
        // The default is to use core:AdminPassword, but it can be replaced with
        // any authentication source.

        'core:AdminPassword',
    ),


    'example-userpass' => array(
      'exampleauth:UserPass',
      
      // Give the user an option to save their username for future login attempts
      // And when enabled, what should the default be, to save the username or not
      //'remember.username.enabled' => FALSE,
      //'remember.username.checked' => FALSE,
      
      'test:test' => array(
        'uid' => array('test'),
        'eduPersonAffiliation' => array('member', 'student'),
      ),
      'employee:employeepass' => array(
        'uid' => array('employee'),
        'eduPersonAffiliation' => array('member', 'employee'),
      ),
    )

);

foreach(array('cholland', 'cthompson', 'dpaul', 'hcarpenter', 'jdoten', 'jeshelman', 'jkang', 'mwhiddon', 'mwilson', 'rbrady', 'rdavis', 'rfukasawa', 'scates', 'vkoch') as $user) {
  $config['example-userpass']["$user:$user"] = array(
    'uid' => array($user),
    //'eduPersonAffiliation' => array('member', 'student'),
  );
}
