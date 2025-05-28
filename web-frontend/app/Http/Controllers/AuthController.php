<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class AuthController extends Controller
{
    public function showLogin()
    {
        return view('auth.login');
    }

    public function login(Request $request)
    {
        $response = Http::post('http://localhost:5000/api/auth/login', [
            'email' => $request->email,
            'password' => $request->password,
        ]);

        if ($response->successful()) {
            session([
                'token' => $response['token'],
                'user' => $response['user']
            ]);
            return redirect('/dashboard');
        }

        return back()->withErrors(['message' => 'Invalid credentials']);
    }

    public function showRegister()
    {
        return view('auth.register');
    }

    public function register(Request $request)
    {
        $response = Http::post('http://localhost:5000/api/auth/register', $request->only('email', 'password', 'name'));

        if ($response->successful()) {
            session([
                'token' => $response['token'],
                'user' => $response['user']
            ]);
            return redirect('/dashboard');
        }

        return back()->withErrors(['message' => 'Registration failed']);
    }

    public function logout()
    {
        session()->flush();
        return redirect('/login');
    }
}
