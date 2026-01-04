import 'package:flutter/material.dart';

class MainContent extends StatelessWidget {
  final String selectedMenu;

  const MainContent({
    super.key,
    required this.selectedMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade50,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPageHeader(),
            const SizedBox(height: 24),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildPageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getPageTitle(),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _getPageSubtitle(),
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    switch (selectedMenu) {
      case 'home':
        return _buildHomeContent();
      case 'users':
        return _buildUsersContent();
      case 'settings':
        return _buildSettingsContent();
      default:
        return _buildDefaultContent();
    }
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        // 統計卡片
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              // 小螢幕：單列顯示
              return Column(
                children: [
                  _buildStatCard('總用戶數', '1,234', Icons.people, Colors.blue),
                  const SizedBox(height: 16),
                  _buildStatCard('今日訂單', '56', Icons.shopping_cart, Colors.green),
                  const SizedBox(height: 16),
                  _buildStatCard('總收入', '\$12,345', Icons.attach_money, Colors.orange),
                  const SizedBox(height: 16),
                  _buildStatCard('待處理', '8', Icons.pending_actions, Colors.red),
                ],
              );
            } else {
              // 大螢幕：單行顯示
              return Row(
                children: [
                  Expanded(child: _buildStatCard('總用戶數', '1,234', Icons.people, Colors.blue)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard('今日訂單', '56', Icons.shopping_cart, Colors.green)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard('總收入', '\$12,345', Icons.attach_money, Colors.orange)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard('待處理', '8', Icons.pending_actions, Colors.red)),
                ],
              );
            }
          },
        ),
        const SizedBox(height: 24),
        // 圖表區域
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: _buildCard(
                '銷售趨勢',
                Container(
                  height: 300,
                  alignment: Alignment.center,
                  child: const Text('圖表區域'),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildCard(
                '最新活動',
                Column(
                  children: List.generate(
                    5,
                    (index) => _buildActivityItem(
                      '用戶 ${index + 1} 完成了訂單',
                      '${index + 1} 分鐘前',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUsersContent() {
    return _buildCard(
      '用戶列表',
      Column(
        children: [
          // 工具列
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '搜尋用戶...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('新增用戶'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 用戶表格
          _buildDataTable(),
        ],
      ),
    );
  }

  Widget _buildSettingsContent() {
    return Column(
      children: [
        _buildCard(
          '一般設定',
          Column(
            children: [
              _buildSettingItem('網站名稱', '後台管理系統'),
              _buildSettingItem('語言', '繁體中文'),
              _buildSettingItem('時區', 'GMT+8'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildCard(
          '通知設定',
          Column(
            children: [
              _buildSwitchItem('郵件通知', true),
              _buildSwitchItem('推送通知', false),
              _buildSwitchItem('簡訊通知', false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultContent() {
    return _buildCard(
      '內容區域',
      Container(
        height: 400,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              '此頁面正在建設中',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(icon, color: color, size: 24),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, Widget child) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14)),
                Text(
                  time,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    return Card(
      child: DataTable(
        columns: const [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('姓名')),
          DataColumn(label: Text('Email')),
          DataColumn(label: Text('角色')),
          DataColumn(label: Text('狀態')),
          DataColumn(label: Text('操作')),
        ],
        rows: List.generate(
          5,
          (index) => DataRow(
            cells: [
              DataCell(Text('${index + 1}')),
              DataCell(Text('用戶 ${index + 1}')),
              DataCell(Text('user${index + 1}@example.com')),
              DataCell(Text(index == 0 ? '管理員' : '一般用戶')),
              DataCell(
                Chip(
                  label: const Text('啟用'),
                  backgroundColor: Colors.green.shade100,
                  labelStyle: const TextStyle(color: Colors.green, fontSize: 12),
                ),
              ),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 18),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchItem(String label, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Switch(
            value: value,
            onChanged: (bool newValue) {},
          ),
        ],
      ),
    );
  }

  String _getPageTitle() {
    switch (selectedMenu) {
      case 'home':
        return '儀表板';
      case 'users':
        return '用戶管理';
      case 'products':
        return '產品管理';
      case 'orders':
        return '訂單管理';
      case 'analytics':
        return '數據分析';
      case 'settings':
        return '系統設定';
      default:
        return '頁面';
    }
  }

  String _getPageSubtitle() {
    switch (selectedMenu) {
      case 'home':
        return '查看系統概覽和統計資訊';
      case 'users':
        return '管理系統用戶和權限';
      case 'products':
        return '管理產品資訊和庫存';
      case 'orders':
        return '查看和處理訂單';
      case 'analytics':
        return '查看詳細的數據分析';
      case 'settings':
        return '配置系統參數';
      default:
        return '頁面描述';
    }
  }
}
