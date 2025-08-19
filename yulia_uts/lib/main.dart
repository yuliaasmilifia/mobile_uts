import 'package:flutter/material.dart';

// MODEL MENU
class Menu {
  final String nama;
  final String gambar;
  final int harga;

  Menu({required this.nama, required this.gambar, required this.harga});
}

// MODEL PESANAN
class Pesanan {
  final Menu menu;
  int jumlah;

  Pesanan({required this.menu, this.jumlah = 1});

  int get totalHarga => menu.harga * jumlah;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Pemesanan',
      theme: ThemeData(primarySwatch: Colors.teal, useMaterial3: true),
      home: MenuView(),
    );
  }
}

class MenuView extends StatefulWidget {
  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  final List<Menu> daftarMenu = [
    Menu(nama: "Es Teh Manis", gambar: "assets/images/esteh.jpeg", harga: 5000),
    Menu(nama: "Es Jeruk", gambar: "assets/images/esjeruk.jpeg", harga: 7000),
    Menu(nama: "Kopi Hitam", gambar: "assets/images/kopi.jpeg", harga: 10000),
    Menu(nama: "Mie Goreng", gambar: "assets/images/miegor.jpeg", harga: 15000),
    Menu(
      nama: "Nasi Goreng",
      gambar: "assets/images/nasgor.jpeg",
      harga: 20000,
    ),
  ];

  final List<Pesanan> keranjang = [];

  void tambahPesanan(Menu menu) {
    setState(() {
      final index = keranjang.indexWhere((p) => p.menu.nama == menu.nama);
      if (index != -1) {
        keranjang[index].jumlah++;
      } else {
        keranjang.add(Pesanan(menu: menu));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Menu"),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PesananView(keranjang: keranjang),
                    ),
                  );
                },
              ),
              if (keranjang.isNotEmpty)
                Positioned(
                  right: 5,
                  top: 5,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      keranjang.length.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: daftarMenu.length,
        itemBuilder: (context, index) {
          final menu = daftarMenu[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                    child: Image.asset(
                      menu.gambar,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Text(
                        menu.nama,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "Rp ${menu.harga}",
                        style: const TextStyle(color: Colors.teal),
                      ),
                      const SizedBox(height: 5),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text("Pesan"),
                        onPressed: () => tambahPesanan(menu),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PesananView extends StatefulWidget {
  final List<Pesanan> keranjang;

  const PesananView({super.key, required this.keranjang});

  @override
  State<PesananView> createState() => _PesananViewState();
}

class _PesananViewState extends State<PesananView> {
  @override
  Widget build(BuildContext context) {
    int totalMenu = widget.keranjang.fold(0, (sum, item) => sum + item.jumlah);
    int totalHarga = widget.keranjang.fold(
      0,
      (sum, item) => sum + item.totalHarga,
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Pesanan"), centerTitle: true),
      body: widget.keranjang.isEmpty
          ? const Center(child: Text("Belum ada pesanan"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.keranjang.length,
                    itemBuilder: (context, index) {
                      final pesanan = widget.keranjang[index];
                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          leading: Image.asset(
                            pesanan.menu.gambar,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(pesanan.menu.nama),
                          subtitle: Text(
                            "Rp ${pesanan.menu.harga} x ${pesanan.jumlah} = Rp ${pesanan.totalHarga}",
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle),
                                onPressed: () {
                                  setState(() {
                                    if (pesanan.jumlah > 1) {
                                      pesanan.jumlah--;
                                    } else {
                                      widget.keranjang.removeAt(index);
                                    }
                                  });
                                },
                              ),
                              Text(pesanan.jumlah.toString()),
                              IconButton(
                                icon: const Icon(Icons.add_circle),
                                onPressed: () {
                                  setState(() {
                                    pesanan.jumlah++;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade100,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Total Jumlah Menu: $totalMenu",
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Total Harga: Rp $totalHarga",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.check),
                        label: const Text("Selesaikan Pesanan"),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Pesanan berhasil!")),
                          );
                          setState(() {
                            widget.keranjang.clear();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
