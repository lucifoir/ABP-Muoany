<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Register - Moany</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gray-100 min-h-screen flex items-center justify-center">

    <div class="bg-white w-full max-w-5xl h-[600px] rounded-xl shadow-lg overflow-hidden flex">

        {{-- LEFT: Form --}}
        <div class="w-1/2 p-10 flex flex-col justify-center">
            <div class="mb-8">
                <h2 class="text-3xl font-bold text-gray-800">Create an Account</h2>
                <p class="text-sm text-gray-500 mt-1">Join Moany and take control of your finances.</p>
            </div>

            @if($errors->any())
                <div class="text-red-600 text-sm mb-2">{{ $errors->first() }}</div>
            @endif

            <form method="POST" action="/register" class="space-y-4">
                @csrf
                <input name="name" type="text" placeholder="Full Name" required
                    class="w-full border rounded-md p-3 text-sm focus:outline-none focus:ring-2 focus:ring-blue-400" />
                <input name="email" type="email" placeholder="Email Address" required
                    class="w-full border rounded-md p-3 text-sm focus:outline-none focus:ring-2 focus:ring-blue-400" />
                <input name="password" type="password" placeholder="Password" required
                    class="w-full border rounded-md p-3 text-sm focus:outline-none focus:ring-2 focus:ring-blue-400" />
                <input name="password_confirmation" type="password" placeholder="Confirm Password" required
                    class="w-full border rounded-md p-3 text-sm focus:outline-none focus:ring-2 focus:ring-blue-400" />

                <button type="submit"
                    class="w-full bg-blue-500 text-white p-3 rounded-md font-medium hover:bg-blue-600 transition">Sign
                    Up</button>

                <p class="text-sm text-center text-gray-500 mt-4">
                    Already have an account?
                    <a href="{{ route('login') }}" class="text-blue-600 hover:underline font-medium">Login here</a>
                </p>
            </form>
        </div>

        {{-- RIGHT: Image --}}
        <div class="w-1/2 bg-blue-100 relative flex items-center justify-center">
            <img src="{{ asset('images/login-illustration.png') }}" alt="..." class="w-full h-full object-cover">
        </div>

    </div>

</body>

</html>