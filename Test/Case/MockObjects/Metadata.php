<?php

class Metadata extends CakeTestModel
{
    /**
     * @var string
     */
    public $name = 'Metadata';

    /**
     * @var string[]
     */
    public $hasOne = array('Document');
}
