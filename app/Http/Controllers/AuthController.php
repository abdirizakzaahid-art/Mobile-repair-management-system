<?php
namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function form() { return session()->has('user') ? redirect()->route('dashboard') : view('auth.login'); }
    public function login(Request $request) {
        $credentials = $request->validate(['email'=>'required|email','password'=>'required|string']);
        $user = DB::table('users')->where('email', strtolower($credentials['email']))->first();
        if (!$user || $user->status !== 'active' || !Hash::check($credentials['password'], $user->password)) return back()->withInput($request->only('email'))->with('error', 'Invalid email or password.');
        $request->session()->regenerate();
        $data = (array) $user; unset($data['password']); $request->session()->put('user', $data);
        log_activity('login', 'user', (int)$user->id, 'User signed in');
        return redirect()->intended(route('dashboard'));
    }
    public function logout(Request $request) {
        if (current_user()) log_activity('logout', 'user', (int)current_user()['id'], 'User signed out');
        $request->session()->invalidate(); $request->session()->regenerateToken();
        return redirect()->route('login');
    }
}
