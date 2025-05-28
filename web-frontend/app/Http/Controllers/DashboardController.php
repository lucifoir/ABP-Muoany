<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Carbon\Carbon;

class DashboardController extends Controller
{
    public function index()
    {
        $token = session('token');
        $response = Http::withToken($token)->get('http://localhost:5000/api/records');
        $records = $response->json()['records'];

        $budgetResponse = Http::withToken($token)->get('http://localhost:5000/api/budgets');

        if ($budgetResponse->successful()) {
            $budgets = $budgetResponse->json()['budgets'];
        } else {
            $budgets = []; // fallback if API fails
        }
        $today = Carbon::today();
        $startOfWeek = Carbon::now()->startOfWeek();
        $endOfWeek = Carbon::now()->endOfWeek();
        $currentMonth = Carbon::now()->format('Y-m');

        $dailyExpense = collect($records)
            ->where('type', 'expense')
            ->filter(fn($r) => Carbon::parse($r['transaction_date'])->isSameDay($today))
            ->sum('amount');

        $weeklyExpense = collect($records)
            ->where('type', 'expense')
            ->filter(fn($r) => Carbon::parse($r['transaction_date'])->between($startOfWeek, $endOfWeek))
            ->sum('amount');

        // Grouping by current and last month
        $currentMonth = Carbon::now()->format('Y-m');
        $lastMonth = Carbon::now()->subMonth()->format('Y-m');

        $monthlyExpense = collect($records)
            ->where('type', 'expense')
            ->filter(fn($r) => str_starts_with($r['transaction_date'], $currentMonth))
            ->sum('amount');

        $lastMonthExpense = collect($records)
            ->where('type', 'expense')
            ->filter(fn($r) => str_starts_with($r['transaction_date'], $lastMonth))
            ->sum('amount');

        $monthlyIncome = collect($records)
            ->where('type', 'income')
            ->filter(fn($r) => str_starts_with($r['transaction_date'], $currentMonth))
            ->sum('amount');

        $lastMonthIncome = collect($records)
            ->where('type', 'income')
            ->filter(fn($r) => str_starts_with($r['transaction_date'], $lastMonth))
            ->sum('amount');

        $expenseDiff = $lastMonthExpense > 0
            ? round((($monthlyExpense - $lastMonthExpense) / $lastMonthExpense) * 100)
            : ($monthlyExpense > 0 ? 100 : 0);
        $incomeDiff = $lastMonthIncome ? round((($monthlyIncome - $lastMonthIncome) / $lastMonthIncome) * 100) : 0;

        $income = collect($records)->where('type', 'income')->sum('amount');
        $expense = collect($records)->where('type', 'expense')->sum('amount');
        $balance = $income - $expense;

        $balance = $monthlyIncome - $monthlyExpense;
        $lastMonthBalance = $lastMonthIncome - $lastMonthExpense;

        $balanceDiff = $lastMonthBalance != 0
            ? round((($balance - $lastMonthBalance) / $lastMonthBalance) * 100)
            : ($balance > 0 ? 100 : 0);

        $colorMap = [
            'Housing' => '#F87171',             // red-400
            'Utilities' => '#FB923C',           // orange-400
            'Groceries' => '#FBBF24',           // yellow-400
            'Health' => '#34D399',              // green-400
            'Debt Payment' => '#60A5FA',        // blue-400
            'Education' => '#A78BFA',           // purple-400
            'Entertainment' => '#10B981',       // emerald-500
            'Travel' => '#F472B6',              // pink-400
            'Donation' => '#FACC15',            // yellow-300
            'Investment' => '#4ADE80',          // green-300
            'Food' => '#3B82F6',                // blue-500
            'Shopping' => '#F97316',            // orange-500
            'Transport' => '#38BDF8',           // sky-400

            // Income categories
            'Business Income' => '#22C55E',     // green-500
            'Government Benefits' => '#7C3AED', // violet-600
            'Salary' => '#16A34A',              // green-600
            'Passive' => '#8B5CF6',             // purple-500
            'Other' => '#9CA3AF',               // gray-400

            // fallback color if category not found
            'default' => '#A3A3A3'              // gray-500
        ];

        $currentMonth = Carbon::now()->format('Y-m');

        $chartData = collect($records)
            ->filter(fn($r) => str_starts_with($r['transaction_date'], $currentMonth)) // ✅ only current month
            ->groupBy(fn($r) => $r['type'] . '_' . $r['category_name'])
            ->map(function ($group, $key) {
                [$type, $category] = explode('_', $key);
                return [
                    'type' => $type,
                    'category' => $category,
                    'total' => collect($group)->sum('amount'),
                ];
            })->values();

        $chartData = $chartData->map(function ($item) use ($chartData, $colorMap) {
            $typeTotal = $chartData->where('type', $item['type'])->sum('total');

            return [
                ...$item,
                'percentage' => $typeTotal > 0 ? round(($item['total'] / $typeTotal) * 100) : 0,
                'color' => $colorMap[$item['category']] ?? $colorMap['default'],
            ];
        });

        $barChartData = [
            'labels' => [],
            'income' => [],
            'expense' => [],
        ];

        foreach (range(1, 12) as $month) {
            $label = Carbon::create()->month($month)->format('M');
            $barChartData['labels'][] = $label;
            $barChartData['income'][] = collect($records)->where('type', 'income')->filter(function ($r) use ($month) {
                return Carbon::parse($r['transaction_date'])->month === $month;
            })->sum('amount');
            $barChartData['expense'][] = collect($records)->where('type', 'expense')->filter(function ($r) use ($month) {
                return Carbon::parse($r['transaction_date'])->month === $month;
            })->sum('amount');
        }

        $averageIncome = collect($barChartData['income'])->avg();
        $lastMonthAverageIncome = $lastMonthIncome; // or calculate average if monthly
        $averageIncomeDiff = $lastMonthAverageIncome != 0
            ? round((($averageIncome - $lastMonthAverageIncome) / $lastMonthAverageIncome) * 100)
            : ($averageIncome > 0 ? 100 : 0);

        $averageExpense = collect($barChartData['expense'])->avg();
        $lastMonthAverageExpense = $lastMonthExpense;
        $averageExpenseDiff = $lastMonthAverageExpense != 0
            ? round((($averageExpense - $lastMonthAverageExpense) / $lastMonthAverageExpense) * 100)
            : ($averageExpense > 0 ? 100 : 0);


        $categories = [
            'Housing',
            'Utilities',
            'Groceries',
            'Health',
            'Debt Payment',
            'Education',
            'Entertainment',
            'Travel',
            'Donation',
            'Investment',
            'Food',
            'Shopping',
            'Transport',
            'Business Income',
            'Government Benefits',
            'Salary',
            'Passive',
            'Other'
        ];

        return view('dashboard', compact(
            'records',
            'monthlyIncome',
            'monthlyExpense',
            'incomeDiff',
            'expenseDiff',
            'balance',
            'chartData',
            'barChartData',
            'lastMonthIncome',
            'lastMonthExpense',
            'balanceDiff',
            'lastMonthBalance',
            'averageIncome',
            'averageExpense',
            'averageIncomeDiff',
            'averageExpenseDiff',
            'lastMonthAverageIncome',
            'lastMonthAverageExpense',
            'chartData',
            'dailyExpense',
            'weeklyExpense',
            'monthlyExpense',
            'budgets',
            'categories',
        ));
    }

}