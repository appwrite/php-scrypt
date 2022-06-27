<?php

use PHPUnit\Framework\TestCase;

final class ScryptTest extends TestCase
{
    public function setUp(): void
    {
    }

    public function tearDown(): void
    {
    }

    /** 
     * Expect Success
     */
    public function testDefaults(): void
    {
        $hash = scrypt('password', 'salt');

        $this->assertEquals('4bc0fd507e93a600', $hash);
    }

    /** 
     * Expect Success
     */
    public function testDefaultsWithParams(): void
    {
        $hash = scrypt('password', 'salt', 16384, 8, 1, 64);

        $this->assertEquals('745731af4484f323968969eda289aeee005b5903ac561e64a5aca121797bf7734ef9fd58422e2e22183bcacba9ec87ba0c83b7a2e788f03ce0da06463433cda6', $hash);
    }

    /** 
     * Expect Failure
     */
    public function testInvalidParams(): void
    {
        $this->expectException(Exception::class);

        scrypt('password', 'salt', 0, 0, 0, 0);
    }

    /** 
     * Expect Failure
     */
    public function testInvalidSalt(): void
    {
        $this->expectException(Exception::class);

        scrypt('password', null, 16384, 8, 1, 64);
    }
}