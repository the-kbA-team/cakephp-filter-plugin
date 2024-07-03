<?php

App::uses('Controller', 'Controller');

/**
 * @property array<mixed> $filters
 * @property FilterComponent $Filter
 * @property Document $Document
 */
class DocumentTestsController extends Controller
{
    /**
     * @var string
     */
    public $name = 'DocumentTests';

    public function index(): void
    {
    }

    // must override this or the tests never complete..
    // @TODO: mock partial?
    /**
     * @param array<mixed>|string $url
     * @param array<mixed> $status
     * @param bool $exit
     * @return CakeResponse|null
     */
    public function redirect($url, $status = null, $exit = true)
    {
        return $this->response;
    }
}
