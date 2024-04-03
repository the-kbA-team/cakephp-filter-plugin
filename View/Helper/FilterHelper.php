<?php
/**
 * CakePHP Filter Plugin
 *
 * Copyright (C) 2009-3827 dr. Hannibal Lecter / lecterror
 * <http://lecterror.com/>
 *
 * Multi-licensed under:
 * MPL <http://www.mozilla.org/MPL/MPL-1.1.html>
 * LGPL <http://www.gnu.org/licenses/lgpl.html>
 * GPL <http://www.gnu.org/licenses/gpl.html>
 */
App::uses('AppHelper', 'View/Helper');

class FilterHelper extends AppHelper
{
    /**
     * @var View
     */
    protected $_view = null;

    /**
     * @param View $view
     * @param array<mixed> $settings
     */
    public function __construct(View $view, array $settings = array())
    {
        parent::__construct($view, $settings);
        $this->_view = $view;
    }

    /**
     * @param string $modelName
     * @param array<mixed> $options
     * @return string
     */
    public function filterForm(string $modelName, array $options): string
    {
        $view =& $this->_view;

        $output = $view->element(
            'filter_form_begin',
            array(
                'plugin' => 'Filter',
                'modelName' => $modelName,
                'options' => $options
            ),
            array('plugin' => 'Filter')
        );

        $output .= $view->element(
            'filter_form_fields',
            array('plugin' => 'Filter'),
            array('plugin' => 'Filter')
        );

        $output .= $view->element(
            'filter_form_end',
            array('plugin' => 'Filter'),
            array('plugin' => 'Filter')
        );

        return $output;
    }

    /**
     * @param string $modelName
     * @param array<mixed> $options
     * @return string
     */
    public function beginForm(string $modelName, array $options): string
    {
        $view =& $this->_view;
        $output = $view->element(
            'filter_form_begin',
            array(
                'plugin' => 'Filter',
                'modelName' => $modelName,
                'options' => $options
            ),
            array('plugin' => 'Filter')
        );

        return $output;
    }

    /**
     * @param array<mixed> $fields
     * @return string
     */
    public function inputFields(array $fields = array()): string
    {
        $view =& $this->_view;
        $output = $view->element(
            'filter_form_fields',
            array(
                'plugin' => 'Filter',
                'includeFields' => $fields
            ),
            array('plugin' => 'Filter')
        );

        return $output;
    }

    public function endForm(): string
    {
        $view = $this->_view;
        $output = $view->element(
            'filter_form_end',
            array(),
            array('plugin' => 'Filter')
        );

        return $output;
    }
}
