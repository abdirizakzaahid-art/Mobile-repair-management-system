@extends('layouts.app')
@section('title',ucfirst($role).' Dashboard')
@section('subtitle','Welcome back, '.current_user()['name'].' — here is today’s service overview')
@section('content')
<div class="row g-3 mb-4">
    @if($role!=='technician')
    <div class="col-6 col-xl-3"><div class="card metric-card stat-blue"><div class="d-flex justify-content-between"><div><div class="metric-label">Total Customers</div><div class="metric-value text-primary">{{ $stats['customers'] }}</div><div class="metric-meta">Registered customer profiles</div></div><div class="metric-icon bg-primary-subtle text-primary"><i class="bi bi-people"></i></div></div></div></div>
    @endif
    <div class="col-6 col-xl-3"><div class="card metric-card stat-orange"><div class="d-flex justify-content-between"><div><div class="metric-label">{{ $role==='technician'?'Assigned Repairs':'Pending Repairs' }}</div><div class="metric-value text-warning">{{ $stats['pending'] }}</div><div class="metric-meta">{{ $stats['today'] }} new ticket(s) today</div></div><div class="metric-icon bg-warning-subtle text-warning"><i class="bi bi-hourglass-split"></i></div></div></div></div>
    <div class="col-6 col-xl-3"><div class="card metric-card stat-green"><div class="d-flex justify-content-between"><div><div class="metric-label">Completed Repairs</div><div class="metric-value text-success">{{ $stats['completed'] }}</div><div class="metric-meta">{{ $stats['completion_rate'] }}% completion rate</div></div><div class="metric-icon bg-success-subtle text-success"><i class="bi bi-check2-circle"></i></div></div></div></div>
    @if($role!=='technician')
    <div class="col-6 col-xl-3"><div class="card metric-card stat-purple"><div class="d-flex justify-content-between"><div><div class="metric-label">Monthly Revenue</div><div class="metric-value" style="color:#7856d8">{{ money($stats['revenue']) }}</div><div class="metric-meta">Payments received this month</div></div><div class="metric-icon" style="background:#f0ebff;color:#7856d8"><i class="bi bi-cash-stack"></i></div></div></div></div>
    @endif
</div>

<div class="row g-4 mb-4">
    <div class="col-xl-7"><div class="card h-100"><div class="card-header d-flex justify-content-between"><div><strong>Repairs Overview</strong><div class="text-secondary" style="font-size:9px">New repair tickets during the last seven days</div></div><span class="badge text-bg-light">This week</span></div><div class="card-body" style="height:260px"><canvas id="trendChart"></canvas></div></div></div>
    <div class="col-xl-5"><div class="card h-100"><div class="card-header d-flex justify-content-between"><div><strong>Repair Status</strong><div class="text-secondary" style="font-size:9px">Current workload distribution</div></div><span class="badge text-bg-primary">Live</span></div><div class="card-body" style="height:260px"><canvas id="statusChart"></canvas></div></div></div>
</div>

<div class="card mb-4"><div class="card-header d-flex justify-content-between"><div><strong>{{ $role==='technician'?'My Latest Assignments':'Recent Repair Tickets' }}</strong><div class="text-secondary" style="font-size:9px">Latest service activity across the repair center</div></div><a href="{{ route('repairs.index') }}" class="btn btn-sm btn-outline-primary">View all repairs <i class="bi bi-arrow-right ms-1"></i></a></div><div class="table-responsive"><table class="table mb-0"><thead><tr><th>Ticket No.</th><th>Customer</th><th>Device</th><th>Status</th><th>Technician</th><th>Priority</th><th></th></tr></thead><tbody>@forelse($recent as $x)<tr><td><a class="fw-semibold" href="{{ route('repairs.show',$x->id) }}">{{ $x->ticket_no }}</a></td><td>{{ $x->customer_name }}</td><td>{{ $x->brand }} {{ $x->model }}</td><td>{!! status_badge($x->status) !!}</td><td>{{ $x->technician_name ?: 'Unassigned' }}</td><td><span class="badge text-bg-{{ $x->priority==='urgent'?'danger':($x->priority==='high'?'warning':'secondary') }}">{{ ucfirst($x->priority) }}</span></td><td><a href="{{ route('repairs.show',$x->id) }}" class="btn btn-sm btn-light"><i class="bi bi-eye"></i></a></td></tr>@empty<tr><td colspan="7"><div class="empty-state"><i class="bi bi-tools"></i>No repair records yet.</div></td></tr>@endforelse</tbody></table></div></div>

<div class="row g-3">
    @if(is_role('admin','receptionist'))
    <div class="col-md-4"><a class="card quick-action" href="{{ route('customers.create') }}"><span class="metric-icon bg-primary-subtle text-primary"><i class="bi bi-person-plus"></i></span><span><strong>Register New Customer</strong><small>Add customer and device information</small></span></a></div>
    <div class="col-md-4"><a class="card quick-action" href="{{ route('repairs.create') }}"><span class="metric-icon bg-success-subtle text-success"><i class="bi bi-ticket-perforated"></i></span><span><strong>Create Repair Ticket</strong><small>Assign a device and technician</small></span></a></div>
    <div class="col-md-4"><a class="card quick-action" href="{{ route('track') }}"><span class="metric-icon bg-warning-subtle text-warning"><i class="bi bi-search"></i></span><span><strong>Public Repair Tracking</strong><small>Search ticket progress for a customer</small></span></a></div>
    @else
    <div class="col-md-6"><a class="card quick-action" href="{{ route('repairs.index') }}"><span class="metric-icon bg-primary-subtle text-primary"><i class="bi bi-tools"></i></span><span><strong>View Assigned Repairs</strong><small>Open the complete technician work queue</small></span></a></div>
    <div class="col-md-6"><div class="card quick-action"><span class="metric-icon bg-success-subtle text-success"><i class="bi bi-graph-up-arrow"></i></span><span><strong>{{ $stats['completion_rate'] }}% Completion Rate</strong><small>Your current repair performance</small></span></div></div>
    @endif
</div>
@push('scripts')
<script>
Chart.defaults.font.family='Inter';Chart.defaults.font.size=9;Chart.defaults.color='#758197';
new Chart(document.getElementById('trendChart'),{type:'line',data:{labels:@json($trend->pluck('label')),datasets:[{label:'New Repairs',data:@json($trend->pluck('total')),borderColor:'#075dcc',backgroundColor:'rgba(7,93,204,.09)',fill:true,tension:.4,borderWidth:2,pointRadius:3,pointBackgroundColor:'#fff',pointBorderWidth:2}]},options:{responsive:true,maintainAspectRatio:false,plugins:{legend:{display:false}},scales:{x:{grid:{display:false}},y:{beginAtZero:true,ticks:{precision:0},grid:{color:'#eef1f5'}}}}});
new Chart(document.getElementById('statusChart'),{type:'doughnut',data:{labels:@json($statuses->map(fn($x)=>ucwords(str_replace('_',' ',$x->status)))),datasets:[{data:@json($statuses->pluck('total')),backgroundColor:['#f2a51a','#20a4d8','#075dcc','#7856d8','#18a66a','#34445a','#e34949'],borderWidth:3,borderColor:'#fff'}]},options:{responsive:true,maintainAspectRatio:false,cutout:'67%',plugins:{legend:{position:'right',labels:{boxWidth:8,boxHeight:8,usePointStyle:true,padding:12}}}}});
</script>
@endpush
@endsection
