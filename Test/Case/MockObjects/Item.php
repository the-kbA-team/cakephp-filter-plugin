<?php

class Item extends CakeTestModel
{
    /**
     * @var string
     */
    public $name = 'Item';

    /**
     * @var string[]
     */
    public $belongsTo = array('Document');
}
