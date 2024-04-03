<?php

class Document3 extends CakeTestModel
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
     * @var null|string
     */
    public $itemToUnset = null;

    /**
     * @param array<string, array<string, mixed>> $query
     * @param array<mixed> $options
     * @return array<mixed>
     */
    public function afterDataFilter(array $query, array $options): array
    {
        if (!is_string($this->itemToUnset)) {
            return $query;
        }

        if (isset($query['conditions'][$this->itemToUnset])) {
            unset($query['conditions'][$this->itemToUnset]);
        }

        return $query;
    }
}
