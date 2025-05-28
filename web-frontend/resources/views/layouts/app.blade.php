<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <title>@yield('title', 'Dashboard')</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gray-100 text-gray-800">
  <div class="flex min-h-screen">

    {{-- Sidebar --}}
    <aside class="w-64 bg-white shadow-md p-6 flex flex-col">
      <h1 class="text-2xl font-bold mb-10">Moany</h1>
      <nav class="space-y-4 text-gray-600">
        <a href="/dashboard" class="block hover:text-blue-600 font-medium">Home</a>
        <a href="/records" class="block hover:text-blue-600">Records</a>
        <a href="/budgets" class="block hover:text-blue-600">Budgets</a>
        <form method="POST" action="/logout" class="mt-10">@csrf
          <button class="text-red-500 hover:underline">Logout</button>
        </form>
      </nav>
    </aside>

    {{-- Main Content --}}
    <div class="flex-1 p-8">
      {{-- Topbar --}}
      <div class="mb-6"></div>
      {{-- Page Content --}}
      @yield('content')
    </div>

  </div>
</body>

</html>