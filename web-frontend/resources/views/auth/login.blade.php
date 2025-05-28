<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Login - MyFinance</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gray-100 min-h-screen flex items-center justify-center">

    <div class="bg-white w-full max-w-5xl h-[600px] rounded-xl shadow-lg overflow-hidden flex">

        {{-- LEFT: Form --}}
        <div class="w-1/2 p-10 flex flex-col justify-center">
            <div class="mb-8">
                <h2 class="text-3xl font-bold text-gray-800">Welcome Back</h2>
                <p class="text-sm text-gray-500 mt-1">Please enter your details</p>
            </div>

            @if($errors->any())
                <div class="text-red-600 text-sm mb-2">{{ $errors->first() }}</div>
            @endif
            @if(session('success'))
                <div class="bg-green-100 text-green-800 text-sm p-3 rounded mb-4">
                    {{ session('success') }}
                </div>
            @endif
            <form method="POST" action="/login" class="space-y-4">
                @csrf
                <input name="email" type="email" placeholder="Email Address" required
                    class="w-full border rounded-md p-3 text-sm focus:outline-none focus:ring-2 focus:ring-blue-400" />
                <input name="password" type="password" placeholder="Password" required
                    class="w-full border rounded-md p-3 text-sm focus:outline-none focus:ring-2 focus:ring-blue-400" />
                <button type="submit"
                    class="w-full bg-blue-500 text-white p-3 rounded-md font-medium hover:bg-blue-600 transition">Continue</button>
                <p class="text-sm text-center text-gray-500 mt-4">
                    Don’t have an account?
                    <a href="{{ route('register') }}" class="text-blue-600 hover:underline font-medium">Register
                        here</a>
                </p>

            </form>

            <div class="mt-6 text-center text-sm text-gray-400">Or continue with</div>
            <div class="mt-2 flex justify-center space-x-4">
                <button class="bg-gray-100 p-2 rounded-full shadow-sm"><img
                        src="https://img.icons8.com/color/24/google-logo.png" /></button>
                <button class="bg-gray-100 p-2 rounded-full shadow-sm"><img
                        src="https://img.icons8.com/ios-filled/24/mac-os.png" /></button>
                <button class="bg-gray-100 p-2 rounded-full shadow-sm"><img
                        src="https://img.icons8.com/fluency/24/facebook-new.png" /></button>
            </div>

            <p class="mt-6 text-xs text-gray-400 text-center px-2">
                Join the millions of smart users who trust us to manage their finances.
            </p>
        </div>

        {{-- RIGHT: Image --}}
        <div class="w-1/2 bg-blue-100 relative flex items-center justify-center">
            <img src="{{ asset('images/login-illustration.png') }}" alt="..." class="w-full h-full object-cover">
        </div>

    </div>

</body>

</html>