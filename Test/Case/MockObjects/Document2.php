<?php

class Document2 extends CakeTestModel
{
    /**
     * @var string
     */
    public $name = 'Document';

    /**
     * @var string
     */
    public $alias = 'Document';

    /**
     * @var string[]
     */
    public $belongsTo = array('DocumentCategory');

    /**
     * @var string[]
     */
    public $hasMany = array('Item');

    /**
     * @var bool
     */
    public $returnValue = false;

    /**
     * @param array<mixed> $query
     * @param array<mixed> $options
     * @return bool
     */
    public function beforeDataFilter(array $query, array $options): bool
    {
        return $this->returnValue;
    }
}
