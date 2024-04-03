<?php

/**
 * @mixin FilteredBehavior
 * @property DocumentCategory $DocumentCategory
 */
class Document extends CakeTestModel
{
    /**
     * @var string
     */
    public $name = 'Document';

    /**
     * @var string[]
     */
    public $belongsTo = array('DocumentCategory');

    /**
     * @var string[]
     */
    public $hasMany = array('Item');

    /**
     * @var array<int|string, mixed>
     */
    public $hasOne = array('Metadata');
}
