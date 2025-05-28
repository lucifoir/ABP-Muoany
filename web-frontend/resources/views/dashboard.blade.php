<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <title>Dashboard - Moany</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <script src="https://unpkg.com/lucide@latest"></script>
  <script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>
</head>

<body class="bg-gray-100 min-h-screen text-gray-800">

  {{-- Top Navigation Bar --}}
  <div class="bg-white px-10 py-4 shadow-sm flex justify-between items-center border-b">
    <div class="flex items-center space-x-4">
      <span class="text-green-600 font-bold text-lg">Muoany</span>
      <span class="bg-gray-100 text-gray-600 text-sm px-3 py-1 rounded-md">Personal account</span>
      <span class="bg-green-100 text-green-700 text-sm px-3 py-1 rounded-md">Dashboard</span>
    </div>

    <div class="mx-10 w-96 relative">
      <input type="text" placeholder="Search" class="w-full px-4 py-2 pr-10 border border-gray-300 rounded-md text-sm">
      <div class="absolute right-3 top-2.5 text-gray-400">
        <i data-lucide="search" class="w-4 h-4 text-gray-400"></i>
      </div>
    </div>

    <div class="flex items-center space-x-4">
      <button class="flex items-center space-x-1 bg-gray-100 px-3 py-1 rounded-md text-sm">
        <i data-lucide="message-square" class="w-4 h-4"></i>
        <span>Chat</span>
      </button>
      <button class="p-2 bg-gray-100 rounded-full">
        <i data-lucide="bell" class="w-5 h-5 text-gray-600"></i>
      </button>
      <div class="flex items-center space-x-2 relative" x-data="{ showDropdown: false }">
        <img src="{{ asset('images/profile.webp') }}" @click="showDropdown = !showDropdown"
          class="w-9 h-9 rounded-full object-cover cursor-pointer">

        <div class="text-sm">
          <p class="font-semibold leading-tight">{{ session('user.name') ?? 'User Name' }}</p>
          <p class="text-gray-400 text-xs">{{ session('user.email') ?? 'user@example.com' }}</p>
        </div>

        <!-- ▼ Dropdown Menu -->
        <div x-show="showDropdown" @click.away="showDropdown = false"
          class="absolute right-0 top-12 bg-white rounded shadow-md w-40 z-50 py-2 text-sm">

          <!-- 🔐 LOGOUT FORM -->
          <form method="POST" action="{{ route('logout') }}">
            @csrf
            <button type="submit" class="w-full text-left px-4 py-2 hover:bg-gray-100">
              Logout
            </button>
          </form>
        </div>
      </div>
    </div>
  </div>

  <div class="mx-auto px-10 py-8 flex gap-6">
    <div class="w-[60%]">
      <div>
        <div class="mb-6">
          <h1 class="text-4xl font-semibold">Welcome back, {{ session('user.name') ?? 'User' }}</h1>
          <p class="text-gray-500 text-m">This is your finance report</p>
        </div>
        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 mb-4">
          {{-- Balance Card --}}
          <div class="bg-white p-5 rounded-xl shadow col-span-1 md:col-span-2 lg:col-span-2">
            <div class="flex items-center mb-2">
              <h3 class="text-sm text-gray-500">My balance</h3>
            </div>
            <div class="flex items-center mt-1">
              <p class="text-2xl font-bold text-gray-800">Rp{{ number_format($balance, 0, ',', '.') }}</p>
              <p class="text-xs ml-3 {{ $balanceDiff >= 0 ? 'text-green-500' : 'text-red-500' }}">
                @if ($lastMonthBalance == 0 && $balance > 0)
          New this month
        @elseif ($balanceDiff > 0)
          +{{ $balanceDiff }}% compared to last month
        @elseif ($balanceDiff < 0)
          {{ $balanceDiff }}% compared to last month
        @else
          No change
        @endif
              </p>
            </div>
            <div class="mt-4 text-sm text-gray-500 tracking-widest">**** **** **** 2472</div>
            <div class="flex space-x-2 mt-4 gap-4">
              <button class="flex-1 px-4 py-2 bg-green-600 text-white rounded text-sm">Send money</button>
              <button class="flex-1 px-4 py-2 bg-green-100 text-green-700 rounded text-sm">Request money</button>
            </div>
          </div>

          {{-- Income Card --}}
          <div class="bg-white p-6 rounded-xl shadow">
            <div class="flex items-center mb-6">
              <i data-lucide="wallet" class="w-5 h-5 text-green-600 mr-2"></i>
            </div>
            <h3 class="text-sm text-gray-500 mb-6">Monthly income</h3>
            <p class="text-3xl text-gray-800">Rp{{ number_format($monthlyIncome, 0, ',', '.') }}</p>
            <p class="text-xs mt-1 {{ $incomeDiff >= 0 ? 'text-green-500' : 'text-red-500' }}">
              @if ($lastMonthIncome == 0 && $monthlyIncome > 0)
          New this month
        @elseif ($incomeDiff > 0)
          +{{ $incomeDiff }}% compared to last month
        @elseif ($incomeDiff < 0)
          {{ $incomeDiff }}% compared to last month
        @else
          No change from last month
        @endif
            </p>
          </div>

          {{-- Expense Card --}}
          <div class="bg-white p-6 rounded-xl shadow">
            <div class="flex items-center mb-6">
              <i data-lucide="wallet" class="w-5 h-5 text-red-500 mr-2"></i>
            </div>
            <h3 class="text-sm text-gray-500 mb-6">Monthly expenses</h3>
            <p class="text-3xl text-gray-800">Rp{{ number_format($monthlyExpense, 0, ',', '.') }}</p>
            <p class="text-xs mt-1 {{ $expenseDiff >= 0 ? 'text-green-500' : 'text-red-500' }}">
              @if ($lastMonthExpense == 0 && $monthlyExpense > 0)
          New this month
        @elseif ($expenseDiff > 0)
          +{{ $expenseDiff }}% compared to last month
        @elseif ($expenseDiff < 0)
          {{ $expenseDiff }}% compared to last month
        @else
          No change from last month
        @endif
            </p>
          </div>
        </div>

        <div class="bg-white p-6 rounded-xl shadow mb-6">
          <div class="flex justify-between items-center mb-4">
            <h3 class="font-semibold text-gray-800">Statistics</h3>
            <!-- <span class="text-sm text-gray-400">Monthly</span> -->
          </div>
          <canvas id="incomeExpenseChart" height="100"></canvas>
          {{-- Averages Below Line Chart --}}
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mt-6 border-t pt-4">
            {{-- Average Income --}}
            <div>
              <p class="text-sm text-gray-500">Average income</p>
              <p class="text-2xl font-semibold text-gray-800">
                Rp{{ number_format($averageIncome ?? 0, 0, ',', '.') }}
              </p>
              <p class="text-xs mt-1">
                <span
                  class="{{ $averageIncomeDiff > 0 ? 'text-green-500' : ($averageIncomeDiff < 0 ? 'text-red-500' : 'text-gray-500') }}">
                  @if ($lastMonthAverageIncome == 0 && $averageIncome > 0)
            New this month
          @elseif ($averageIncomeDiff > 0)
            +{{ $averageIncomeDiff }}% compare to last month
          @elseif ($averageIncomeDiff < 0)
            {{ $averageIncomeDiff }}% compare to last month
          @else
            No change from last month
          @endif
                </span>
              </p>

            </div>

            {{-- Average Expenses --}}
            <div>
              <p class="text-sm text-gray-500">Average expenses</p>
              <p class="text-2xl font-semibold text-gray-800">
                Rp{{ number_format($averageExpense ?? 0, 0, ',', '.') }}
              </p>
              <p class="text-xs mt-1 {{ $averageExpenseDiff >= 0 ? 'text-green-500' : 'text-red-500' }}">
                @if ($lastMonthAverageExpense == 0 && $averageExpense > 0)
          New this month
        @elseif ($averageExpenseDiff > 0)
          +{{ $averageExpenseDiff }}% compare to last month
        @elseif ($averageExpenseDiff < 0)
          {{ $averageExpenseDiff }}% compare to last month
        @else
          No change from last month
        @endif
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="w-[35%]" x-data="{ tab: 'records' }">
      <div class="border-b mb-4">
        <nav class="flex space-x-6 text-sm font-medium text-gray-500">
          <button @click="tab = 'records'" :class="tab === 'records' ? 'text-green-600 border-b-2 border-green-600' : 'border-b-2 border-transparent hover:text-green-600 hover:border-green-600'" class="pb-2 px-6">
            Records
          </button>
          <button @click="tab = 'budgeting'" :class="tab === 'budgeting' ? 'text-green-600 border-b-2 border-green-600' : 'border-b-2 border-transparent hover:text-green-600 hover:border-green-600'" class="pb-2 px-6">
            Budgeting
          </button>
          <button @click="tab = 'tracking'" :class="tab === 'tracking' ? 'text-green-600 border-b-2 border-green-600' : 'border-b-2 border-transparent hover:text-green-600 hover:border-green-600'" class="pb-2 px-6">
            Tracking
          </button>
        </nav>
      </div>

      <!-- Records Content -->
      <div x-show="tab === 'records'" x-data="donutChart()"
        class="transition duration-200 bg-white p-4 rounded-xl shadow mt-[55px] h-[760px]">
        <!-- Header Buttons -->
        <div class="flex justify-between items-center mb-[30px]">
          <!-- Toggle Income/Expense -->
          <div class="flex space-x-2">
            <button @click="type = 'expense'" :class="type === 'expense' ? 'bg-green-600 text-white' : 'bg-gray-100 text-gray-600'" class="px-4 py-1 rounded text-sm">
              Expense
            </button>
            <button @click="type = 'income'" :class="type === 'income' ? 'bg-green-600 text-white' : 'bg-gray-100 text-gray-600'" class="px-4 py-1 rounded text-sm">
              Income
            </button>
          </div>

          <!-- Add Record -->
          <button @click="showModal = true" class="px-4 py-1 bg-green-500 text-white rounded text-sm">
            + Add Record
          </button>
        </div>

        <!-- Summary Numbers -->
        <div class="flex justify-between text-sm text-gray-600 mb-4">
          <div>
            <p>This month</p>
            <p class="font-semibold">
              <span x-show="type === 'expense'">Rp{{ number_format($monthlyExpense, 0, ',', '.') }}</span>
              <span x-show="type === 'income'">Rp{{ number_format($monthlyIncome, 0, ',', '.') }}</span>
            </p>
          </div>
        </div>

        <!-- Donut Chart -->
        <div class="w-[300px] h-[300px] mx-auto relative mb-[50px]">
          <canvas id="donutChart" width="300" height="300"></canvas>
        </div>

        <!-- Legend (optional static or dynamic) -->
        <div class="w-full md:w-1/2 space-y-2 text-sm overflow-y-auto pr-2" style="max-height: 300px;">
          <template x-for="item in chartData.filter(i => i.type === type)" :key="item . category">
            <div class="flex justify-between items-center">
              <div class="flex items-center space-x-2">
                <div class="w-2.5 h-2.5 rounded-full" :style="`background-color: ${item . color}`"></div>
                <span x-text="item.category"></span>
              </div>
              <span x-text="item.percentage.toFixed(2) + '%'"></span>
            </div>
          </template>
        </div>

        <div x-show="showModal" @keydown.escape.window="showModal = false"
          class="fixed inset-0 bg-black bg-opacity-40 flex items-center justify-center z-50" x-transition>
          <div @click.away="showModal = false" class="bg-white w-full max-w-md p-6 rounded-lg shadow-lg" x-transition>
            <h2 class="text-lg font-semibold mb-4">Add New Record</h2>

            <form @submit.prevent="submitForm">
              <div class="mb-3">
                <label class="block text-sm font-medium">Title</label>
                <input x-model="form.description" type="text"
                  class="w-full border border-gray-300 px-3 py-2 rounded mt-1 text-sm" required>
              </div>

              <div class="mb-3">
                <label class="block text-sm font-medium">Amount (Rp)</label>
                <input x-model="form.amount" type="number"
                  class="w-full border border-gray-300 px-3 py-2 rounded mt-1 text-sm" required>
              </div>

              <div class="mb-3">
                <label class="block text-sm font-medium">Type</label>
                <select x-model="form.type" class="w-full border border-gray-300 px-3 py-2 rounded mt-1 text-sm">
                  <option value="expense">Expense</option>
                  <option value="income">Income</option>
                </select>
              </div>

              <div class="mb-3">
                <label class="block text-sm font-medium">Transaction Date</label>
                <input x-model="form.transaction_date" type="date"
                  class="w-full border border-gray-300 px-3 py-2 rounded mt-1 text-sm" required>
              </div>

              <div class="flex justify-end mt-4 space-x-2">
                <button type="button" @click="showModal = false" class="px-4 py-2 text-sm text-gray-600">Cancel</button>
                <button type="submit" class="px-4 py-2 bg-green-600 text-white text-sm rounded">Add</button>
              </div>
            </form>
          </div>
        </div>
      </div>
      <div x-show="tab === 'budgeting'" x-data="budgetModal()" class="transition duration-200 pb-[50px]">
        <div class="pt-[40px] space-y-d">
          <!-- Add Budget Button -->

          <!-- Budget Cards -->
          <div class="grid grid-cols-2 gap-6 mb-[20px]">
            @foreach($budgets as $budget)
            @php
            $limit = max(1, $budget['limit_amount']);
            $spent = $budget['spent_amount'];
            $remaining = $limit - $spent;
            $percentage = round(($spent / $limit) * 100, 2);
            $barWidth = min(100, $percentage);
          @endphp

            {{-- ✅ this div closes INSIDE the loop now --}}
            <div class="bg-white p-6 rounded-xl shadow w-full">
              <div class="flex justify-between items-start mb-3">
              <h3 class="text-base text-gray-600">{{ $budget['category_name'] }}</h3>
              <div class="flex gap-2">
                <button @click="openEditModal({ 
            id: {{ $budget['id'] }}, 
            category_name: '{{ $budget['category_name'] }}', 
            limit_amount: {{ $budget['limit_amount'] }} 
            })" class="text-sm text-blue-600 hover:underline">
                Edit
                </button>
                <button @click="openDeleteModal({{ $budget['id'] }})" class="text-sm text-red-500 hover:underline">
                Delete
                </button>
              </div>
              </div>

              <p class="text-2xl font-bold text-gray-800">
              Rp{{ number_format($budget['spent_amount'], 0, ',', '.') }}
              </p>
              <p class="text-sm text-gray-500 mb-2">
              Limit: Rp{{ number_format($budget['limit_amount'], 0, ',', '.') }} |
              Remaining:
              <span class="{{ $remaining < 0 ? 'text-red-500' : 'text-green-600' }}">
                Rp{{ number_format($remaining, 0, ',', '.') }}
              </span>
              </p>

              <div class="w-full h-3 border border-gray-300 rounded overflow-hidden mt-3 bg-white">
              <div class="h-full {{ $percentage > 100 ? 'bg-red-500' : 'bg-green-500' }}"
                style="width: {{ $barWidth }}%;"></div>
              </div>
            </div>
      @endforeach
          </div>

          <div class="flex justify-start mt-4">
            <button @click="showBudgetModal = true" class="px-4 py-2 bg-green-600 text-white text-sm rounded">
              + Add Budget
            </button>
          </div>
          <div x-show="showDeleteModal" @keydown.escape.window="showDeleteModal = false"
            class="fixed inset-0 bg-black bg-opacity-40 flex items-center justify-center z-50" x-transition>
            <div @click.away="showDeleteModal = false" class="bg-white w-full max-w-md p-6 rounded-lg shadow-lg"
              x-transition>
              <h2 class="text-lg font-semibold mb-4 text-red-600">Confirm Deletion</h2>
              <p class="text-sm text-gray-700 mb-4">Are you sure you want to delete this budget?</p>

              <div class="flex justify-end mt-4 space-x-2">
                <button @click="showDeleteModal = false" class="px-4 py-2 text-sm text-gray-600">Cancel</button>
                <button @click="deleteBudget" class="px-4 py-2 bg-red-600 text-white text-sm rounded">Delete</button>
              </div>
            </div>
          </div>
          <div x-show="showEditModal" @keydown.escape.window="showEditModal = false"
            class="fixed inset-0 bg-black bg-opacity-40 flex items-center justify-center z-50" x-transition>
            <div @click.away="showEditModal = false" class="bg-white w-full max-w-md p-6 rounded-lg shadow-lg"
              x-transition>
              <h2 class="text-lg font-semibold mb-4">Edit Budget</h2>
              <form @submit.prevent="submitEditBudget">
                <div class="mb-3">
                  <label class="block text-sm font-medium">Category</label>
                  <input x-model="editForm.category_name" type="text"
                    class="w-full border border-gray-300 px-3 py-2 rounded mt-1 text-sm" required>
                </div>
                <div class="mb-3">
                  <label class="block text-sm font-medium">Limit Amount (Rp)</label>
                  <input x-model="editForm.limit_amount" type="number"
                    class="w-full border border-gray-300 px-3 py-2 rounded mt-1 text-sm" required>
                </div>
                <div class="flex justify-end mt-4 space-x-2">
                  <button type="button" @click="showEditModal = false"
                    class="px-4 py-2 text-sm text-gray-600">Cancel</button>
                  <button type="submit" class="px-4 py-2 bg-green-600 text-white text-sm rounded">Update</button>
                </div>
              </form>
            </div>
          </div>

          <div x-show="showBudgetModal" @keydown.escape.window="showBudgetModal = false"
            class="fixed inset-0 bg-black bg-opacity-40 flex items-center justify-center z-50" x-transition>
            <div @click.away="showBudgetModal = false" class="bg-white w-full max-w-md p-6 rounded-lg shadow-lg"
              x-transition>
              <h2 class="text-lg font-semibold mb-4">Add New Budget</h2>

              <form @submit.prevent="submitBudget">
                <div class="mb-3">
                  <label class="block text-sm font-medium">Category</label>
                  <select x-model="budgetForm.category_name"
                    class="w-full border border-gray-300 px-3 py-2 rounded mt-1 text-sm" required>
                    <option value="" disabled>Select a category</option>
                    <template x-for="cat in categories" :key="cat">
                      <option :value="cat" x-text="cat"></option>
                    </template>
                  </select>
                </div>

                <div class="mb-3">
                  <label class="block text-sm font-medium">Limit Amount (Rp)</label>
                  <input x-model="budgetForm.limit_amount" type="number"
                    class="w-full border border-gray-300 px-3 py-2 rounded mt-1 text-sm" required>
                </div>

                <div class="flex justify-end mt-4 space-x-2">
                  <button type="button" @click="showBudgetModal = false"
                    class="px-4 py-2 text-sm text-gray-600">Cancel</button>
                  <button type="submit" class="px-4 py-2 bg-green-600 text-white text-sm rounded">Add</button>
                </div>
              </form>
            </div>
          </div>
        </div>

      </div>

      <!-- Tracking Tab -->
      <div x-show="tab === 'tracking'" x-data="trackingData()" class="transition duration-200 pt-[40px]">
        <!-- Filter Area -->
        <div class="mb-4 space-y-3">
          <input type="text" x-model="searchQuery" placeholder="Search by name..."
            class="w-full border border-gray-300 px-4 py-2 rounded-md text-sm" />

          <div class="flex space-x-2">
            <div class="flex-1">
              <label class="text-sm text-gray-600 block mb-1">Start Date</label>
              <input type="date" x-model="startDate"
                class="w-full border border-gray-300 px-3 py-2 rounded-md text-sm" />
            </div>
            <div class="flex-1">
              <label class="text-sm text-gray-600 block mb-1">End Date</label>
              <input type="date" x-model="endDate" class="w-full border border-gray-300 px-3 py-2 rounded-md text-sm" />
            </div>
          </div>
        </div>

        <!-- Scrollable Content -->
        <div class="overflow-y-auto" style="max-height: 630px;">
          <template x-for="(items, date) in filteredGroupedRecords" :key="date">
            <div class="mb-6">
              <h3 class="font-semibold text-gray-700 mb-2" x-text="formatDate(date)"></h3>

              <template x-for="record in items" :key="record . id">
                <div class="bg-white p-4 rounded shadow mb-2">
                  <div class="flex justify-between">
                    <div>
                      <p class="font-medium" x-text="record.description || '(No title)'"></p>
                      <p class="text-sm text-gray-500" x-text="record.category_name + ' (' + record.type + ')'"></p>
                    </div>
                    <div class="text-right">
                      <p :class="record . type === 'income' ? 'text-green-600' : 'text-red-500'" class="font-semibold">
                        <span x-text="'Rp' + Number(record.amount).toLocaleString('id-ID')"></span>
                      </p>
                    </div>
                  </div>
                </div>
              </template>
            </div>
          </template>
        </div>
      </div>

      {{-- Statistics Chart --}}


      <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
      <script src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js" defer></script>
      <script>
        lucide.createIcons(); // ✅ activate Lucide icons

        const ctx = document.getElementById('incomeExpenseChart');
        if (ctx) {
          new Chart(ctx, {
            type: 'line',
            data: {
              labels: @json($barChartData['labels']),
              datasets: [
                {
                  label: 'Total income',
                  data: @json($barChartData['income']),
                  borderColor: '#16a34a',
                  tension: 0.4
                },
                {
                  label: 'Total expenses',
                  data: @json($barChartData['expense']),
                  borderColor: '#f97316',
                  tension: 0.4
                }
              ]
            },
            options: {
              responsive: true,
              plugins: {
                legend: {
                  position: 'top'
                }
              }
            }
          });
        }

        document.addEventListener('alpine:init', () => {
          Alpine.data('donutChart', () => ({
            type: 'expense',
            chart: null,
            chartData: @json($chartData),

            allCategories: [
              'Housing', 'Utilities', 'Groceries', 'Health', 'Debt Payment',
              'Education', 'Entertainment', 'Travel', 'Donation', 'Investment',
              'Food', 'Shopping', 'Transport', 'Business Income',
              'Government Benefits', 'Salary', 'Passive', 'Other'
            ],

            getPercentage(category) {
              const item = this.chartData.find(i => i.category === category && i.type === this.type);
              return item ? item.percentage : 0;
            },
            getColor(category) {
              const item = this.chartData.find(i => i.category === category && i.type === this.type);
              return item ? item.color : '#E5E7EB'; // fallback gray
            },

            init() {
              this.renderChart();
              this.$watch('type', () => this.renderChart());
            },

            renderChart() {
              const ctx = document.getElementById('donutChart').getContext('2d');
              const filtered = this.chartData.filter(i => i.type === this.type);

              const data = {
                labels: filtered.map(i => i.category),
                datasets: [{
                  data: filtered.map(i => i.total),
                  backgroundColor: filtered.map(i => i.color),
                  borderWidth: 8,
                  borderRadius: 10,
                  spacing: 4,
                  hoverOffset: 8
                }]
              };

              if (this.chart) this.chart.destroy();
              this.chart = new Chart(ctx, {
                type: 'doughnut',
                data,
                options: {
                  cutout: '60%',
                  responsive: false,
                  plugins: {
                    legend: { display: false },
                    tooltip: {
                      callbacks: {
                        label: function (context) {
                          return context.label + ': Rp' + Number(context.raw).toLocaleString('id-ID');
                        }
                      }
                    }
                  }
                }
              });
            },

            showModal: false,
            form: {
              description: '',
              amount: '',
              type: 'expense',
              transaction_date: new Date().toISOString().split('T')[0]
            },
            submitForm() {
              // 🔄 Example POST (adjust to your API)
              fetch('http://localhost:5000/api/records', {
                method: 'POST',
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer ' + '{{ session('token') }}'
                },
                body: JSON.stringify(this.form)
              })
                .then(res => res.json())
                .then(data => {
                  console.log('✅ Success Response:', data);
                  alert('Record added!');
                  this.showModal = false;
                  window.location.reload(); // or manually refresh chartData if dynamic
                })
                .catch(err => {
                  console.error('❌ Error:', err);
                  alert('Error adding record');
                  console.error(err);
                });
            },
          }));


        });
        document.addEventListener('alpine:init', () => {
          Alpine.data('budgetModal', () => ({
            showBudgetModal: false,
            showEditModal: false,
            showDeleteModal: false,
            budgetForm: {
              category_name: '',
              limit_amount: '',
            },
            deleteId: null,
            categories: @json($categories),
            openEditModal(budget) {
              this.editForm = { ...budget };
              this.showEditModal = true;
            },
            openDeleteModal(id) {
              this.deleteId = id;
              this.showDeleteModal = true;
            },
            submitBudget() {
              fetch('http://localhost:5000/api/budgets', {
                method: 'POST',
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer ' + '{{ session('token') }}'
                },
                body: JSON.stringify(this.budgetForm)
              })
                .then(res => res.json())
                .then(data => {
                  alert('Budget added!');
                  this.showBudgetModal = false;
                  window.location.reload(); // or update budgets dynamically
                })
                .catch(err => {
                  alert('Error adding budget');
                  console.error(err);
                });
            },
            submitEditBudget() {
              fetch(`http://localhost:5000/api/budgets/${this.editForm.id}`, {
                method: 'PUT',
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer ' + '{{ session('token') }}'
                },
                body: JSON.stringify({
                  category_name: this.editForm.category_name,
                  limit_amount: this.editForm.limit_amount
                })
              })
                .then(res => res.json())
                .then(() => {
                  alert('Budget updated!');
                  this.showEditModal = false;
                  window.location.reload();
                });
            },
            deleteBudget() {
              fetch(`http://localhost:5000/api/budgets/${this.deleteId}`, {
                method: 'DELETE',
                headers: {
                  'Authorization': 'Bearer ' + '{{ session('token') }}'
                }
              })
                .then(res => res.json())
                .then(() => {
                  alert('Budget deleted!');
                  this.showDeleteModal = false;
                  window.location.reload();
                })
                .catch(err => {
                  alert('Error deleting budget');
                  console.error(err);
                });
            }
          }));
        });

        document.addEventListener('alpine:init', () => {
          Alpine.data('trackingData', () => ({
            searchQuery: '',
            startDate: '',
            endDate: '',
            allRecords: @json($records),

            get filteredGroupedRecords() {
              const filtered = this.allRecords.filter(r => {
                const transactionDate = new Date(r.transaction_date);
                const startDate = this.startDate ? new Date(this.startDate + 'T00:00:00') : null;
                const endDate = this.endDate ? new Date(this.endDate + 'T23:59:59') : null;

                const afterStart = startDate ? transactionDate >= startDate : true;
                const beforeEnd = endDate ? transactionDate <= endDate : true;
                const matchSearch = r.description?.toLowerCase().includes(this.searchQuery.toLowerCase());

                const result = matchSearch && afterStart && beforeEnd;
                console.log({ raw: r.transaction_date, afterStart, beforeEnd, matchSearch, result });
                return result;
              });

              const grouped = {};
              for (const record of filtered) {
                const date = record.transaction_date.slice(0, 10);
                if (!grouped[date]) grouped[date] = [];
                grouped[date].push(record);
              }

              return Object.fromEntries(
                Object.entries(grouped).sort((a, b) => new Date(b[0]) - new Date(a[0]))
              );
            },

            formatDate(dateStr) {
              return new Date(dateStr).toLocaleDateString('id-ID', {
                weekday: 'long', year: 'numeric', month: 'long', day: 'numeric'
              });
            }
          }));
        });
      </script>

</body>

</html>