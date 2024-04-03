<?php

/**
 * @mixin FilteredBehavior
 */
class DocumentCategory extends CakeTestModel
{
    /**
     * @var string
     */
    public $name = 'DocumentCategory';

    /**
     * @var string[]
     */
    public $hasMany = array('Document');

    /**
     * @param array<string, array<string, mixed>> $options
     * @return array<mixed>|int|null
     */
    public function customSelector(array $options = array())
    {
        $options['conditions']['DocumentCategory.title LIKE'] = '%T%';
        $options['nofilter'] = true;

        return $this->find('list', $options);
    }
}
