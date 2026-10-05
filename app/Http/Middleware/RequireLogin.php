<?php
namespace App\Http\Middleware;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
class RequireLogin { public function handle(Request $request, Closure $next): Response { return session()->has('user') ? $next($request) : redirect()->route('login')->with('error', 'Please sign in to continue.'); } }
