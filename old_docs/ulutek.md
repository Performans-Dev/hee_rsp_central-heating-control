1. Raspberry Pi Entegrasyon Kartı
Görevler:

Raspberry Pi ile entegre bir özel kartın tasarlanması ve oluşturulması.
8 giriş ve 8 çıkış için GPIO bağlantısının sağlanması.
Genel amaçlar için 4 donanım düğmesinin GPIO üzerinden bağlanması.
Röleler, UART, SPI ve GPIO'ya yönlendirilen girişler/düğmeler için konektörlerin tasarlanması.
Pi üzerinde zaman tutma için pil yedeklemesi de dahil olmak üzere güvenilir güç dağıtımının sağlanması.
Tüm donanım bileşenlerinin Raspberry Pi ve özel uzatma kartları ile test edilerek doğrulanması.
Hedefler:

Prototip kart tasarımının tamamlanması.
Nihai donanım tasarımının ve testlerinin yapılması.
Üretim birimlerinin üretilmesi ve monte edilmesi.
Bağımlılıklar: Donanım-yazılım iletişimi doğrulaması için Gömülü Yazılım Ekibi ile işbirliği yapılması.

1.1
Raspberry Pi Entegrasyon Kartı Tasarımı

Açıklama:

Bu görev, cihazlara GPIO, UART ve SPI arayüzleri üzerinden kontrol etmek için Raspberry Pi ile sorunsuz bir şekilde entegre olan özel bir kartın tasarlanması ve oluşturulmasına odaklanır. Özel kart, röleler, sensörler ve donanım düğmelerinin bağlanmasına izin vermeli ve zaman tutma için pil yedeklemesi ekleyerek kararlı çalışma sağlamalıdır.

Araştırma ve Geliştirme Çalışmaları:

Araştırma Konuları:
Raspberry Pi 4 GPIO pinout şemalarının oluşturulması.
Voltaj seviyeleri ve güç gereksinimleri araştırmalarının yapılması.
GPIO, SPI ve UART cihazlarını bağlamak için en iyi uygulamaların araştırılırması.
Raspberry Pi için pil yedekleme çözümlerinin araştırılması.
Güç kesintisi sırasında zaman tutma için devre tasarımlarının araştırılması.
Boşta kalma sırasında düşük tüketim için verimli güç kaynağı tasarımı yapılması.
Cihazları GPIO (röleler, ışıklar, ısıtıcılar, vb.) aracılığıyla kontrol etmek için devreler nasıl tasarlanır.
Donanım düğmeleri için seken devreler tasarlanması.
Giriş/çıkış sinyallerini koruma devreleri ile izole edilmesi.
Seri uzatma kartları için UART iletişim standartları ve konektörleri.
Analog sensörler ve veri aktarımı için SPI iletişimi.
Röle türleri (örneğin, katı hal veya mekanik).
Sensör entegrasyonu için tasarım hususları (sıcaklık sensörleri, anahtarlar).
GPIO, SPI ve UART devrelerini test etme yöntemleri.
Devre tasarımını doğrulamak için simülasyon araçları.
PCB düzenleme araçları (Altium, Eagle, KiCad).
Maliyet etkin üretim seçenekleri.

Geliştirme:
Girişler, çıkışlar, röleler, düğmeler ve analog sensörler için mevcut GPIO pinlerini eşleştirilmesi.
Harici donanım farklı voltaj seviyeleri kullanıyorsa uygun seviye kaydırma sağlanması.
Güç Kaynağı ve Pil Yedeklemesi ile ilgili geliştirmelerin yapılması
Gerçek Zamanlı Saat (RTC) modülü ekleyin ve kartın güç kesildiğinde zaman tutabilmesi sağlanması.
Güç yönetimi devreleri (örneğin, voltaj regülatörleri, koruma devreleri) uygulanması.
Gerektiğinde izolasyon sağlamak (örneğin, optokaplörler kullanarak) 8 GPIO girişi ve 8 GPIO çıkışı için devreler tasarlayın.
Kolay erişim ve sorun giderme için bağlantı noktaları tasarlayın.
Seri uzatma kartlarıyla sorunsuz entegrasyon için UART konektörü tasarlayın.
Kararlı veri aktarımı sağlamak için 4 analog girişi işlemek üzere SPI arayüzleri uygulayın.
Harici cihazları (ısıtıcılar, soğutucular, vb.) kontrol etmek için röleler için konektörler uygulayın.
Sıcaklık ve anahtarlar gibi çeşitli sensörleri bağlamak için devreler tasarlayın.
Kolay hata ayıklama için test noktaları içeren bir prototip kart oluşturun.
Doğru veri aktarımı ve güç dağıtımı sağlamak için işlevsel testler çalıştırın.
Kompakt, maliyet etkin bir PCB düzeni tasarlayın.
Son test ve doğrulamadan sonra geniş ölçekli üretime hazırlanın.


Gömülü Yazılım Görevi #1: Seri Uzatma Kartları için Firmware Geliştirme
Açıklama:

Gömülü Yazılım Ekibi, seri uzatma kartları için C'de firmware geliştirmekten sorumludur. Firmware, Raspberry Pi ile UART üzerinden iletişim, giriş/çıkış verilerini işlemek ve sıcaklık algılama için NTC analog girişini yönetmekten sorumlu olacaktır. Yazılım, seri bağlı bir kurulumda birden fazla kartı destekleyebilmeli ve gerçek zamanlı işleme sağlamalıdır.

Araştırma ve Geliştirme Çalışmaları:

Araştırma Konuları:
Seri iletişim standartları (UART) ve güvenilir aktarım için veri çerçevelemesi.
Paylaşılan bir hat üzerinde birden fazla adreslenebilir cihazla iletişimin nasıl ele alınacağı.
Gömülü sistemlerde gerçek zamanlı veri işleme teknikleri (kesmeler, otomatik sorgulama, vb.).
Dijital giriş/çıkış olaylarını verimli bir şekilde ele alma yöntemleri.
NTC termistör analog sinyallerini bir ADC (analog-to-digital converter) kullanarak dijital değerlere okumak ve dönüştürmek.
Doğru sıcaklık ölçümleri sağlamak için kalibrasyon teknikleri.
Tek bir hat üzerinde birden fazla cihazı adreslemek için yöntemler (adresleme şemaları, ID atama).
Çatışma olmadan seri bağlı sistemlerde iletişimin nasıl ele alınacağı.
Gerçek zamanlı yanıt verebilmek için gömülü sistemlerde kesmelerin kullanılması.
CPU yükünü azaltmak için kesme temelli iletişim ve G/Ç işleme uygulaması.
Gömülü sistemlerde bellek kullanımını optimize etme teknikleri.
Gerçek zamanlı performansı korurken CPU kullanımını en aza indirme stratejileri.
Gömülü sistemleri ve iletişim protokollerini (örneğin, mantık analizörleri, seri hata ayıklama) test etme teknikleri.
Gerçek zamanlı G/Ç işleme ve sıcaklık okumalarını doğrulama stratejileri.
Gömülü firmware'i uzaktan güncelleme yöntemleri (önyükleme programları, OTA güncellemeleri).
Eksik veya bozuk güncellemelerden korunmak için sağlam firmware güncelleme mekanizmaları sağlama.


Geliştirme:
Raspberry Pi ve uzatma kartları arasında veri alışverişi için özel bir iletişim protokolü uygulayın (adresleme, veri çerçeveleri ve komutlar).
Veri bütünlüğünü sağlamak için hata algılama mekanizmaları (örneğin, CRC, parite bitleri) entegre edin.
Veri paketleri göndermek ve almak, olası iletişim gecikmelerini veya hatalarını ele almak için işlevler geliştirin.
Gerçek Zamanlı G/Ç İşleme
6 dijital girişi okumak ve 6 dijital çıkışı kontrol etmek için firmware rutinleri uygulayın.
Sistemin girişleri gerçek zamanlı olarak, minimum gecikmeyle işlemesini sağlayın.
Sistemi yavaşlatmadan birden fazla cihazı işleyebilen verimli G/Ç kontrol rutinleri yazın.
NTC sensöründen analog girişi okumak için firmware yazın.
Analog sinyalleri sıcaklık verilerine dönüştürmek için bir ADC dönüştürme rutini uygulayın.
Sıcaklık ölçümlerinin doğru ve duyarlı olduğundan emin olmak için firmware'i kalibre edin.
Her seri uzatma kartının benzersiz bir şekilde tanımlanabilmesi için kart adresleme rutinleri uygulayın.
Sadece adreslenen kartın komutlara yanıt vermesini sağlamak için iletişim mantığı geliştirin.
Sorunsuz iletişim ve veri çarpışması olmamasını sağlamak için birden fazla kartla bağlanarak firmware'i test edin.
UART iletişimi ve G/Ç değişiklikleri için kesme hizmet rutinleri (ISR'ler) yazın.
Giriş değişikliklerini veya çıkış olaylarını gerçek zamanlı olarak tespit etmek için olay temelli G/Ç işleme uygulayın.
Firmware'in kaynak sınırlı mikrodenetleyiciler üzerinde çalışabilmesini sağlamak için bellek kullanımını optimize edin.
UART verilerini ve G/Ç olaylarını işlemek için kaynak verimli veri yapıları ve iletişim tamponları uygulayın.
UART iletişimini simüle etmek ve yanıtları izlemek için test senaryoları geliştirin.
Gerçek dünya koşullarında güvenilir dijital giriş/çıkış işleme ve sıcaklık okumalarını test edin.
Farklı senaryolarda (örneğin, tek kart veya birden fazla kart) firmware'i hata ayıklayın.
Uzatma kartları için firmware güncellemelerini kolaylaştıracak bir önyükleme programı uygulayın.
Raspberry Pi tarafından başlatılabilen ve doğrulanabilen firmware güncellemeleri için basit bir protokol tasarlayın.
Başarısız güncelleme girişimlerinden kurtulmasını sağlamak için güncelleme mekanizmasını test edin.



OS Ekibi Görevi #1: Raspberry Pi OS Yapılandırması ve Günlük Sistem Yönetimiyle Optimizasyon
Açıklama:

OS Ekibi, Merkezi Kontrolör (CC) uygulamasını desteklemek için Raspbian (Raspberry Pi OS) ortamını kurma, yapılandırma ve optimize etmekten sorumludur. Bu, önyükleme işlemini yönetmeyi, Flutter uygulamasının başlangıçta çalışmasını sağlamayı, OTA güncellemelerini ele almayı, işletim sistemini güvenli hale getirmeyi ve uygulamanın günlük sistemini yönetmeyi içerir. Günlük sistemi olayları JSON dosyaları olarak kaydeder ve /logfolder/year/month/day/logfile1.json yapısını takip eder. OS ekibi, bağlantı mevcut olduğunda günlükleri periyodik olarak toplamalı ve sunucuya göndermeli ve eski günlükleri temizleyerek yer açmalıdır.

Araştırma ve Geliştirme Çalışmaları:

Flutter Uygulamasının Başlangıçta Otomatik Başlatılması

Araştırma Konuları:
Raspberry Pi başlangıcında uygulamaları otomatik olarak başlatma teknikleri.
Systemd hizmetleri ve başlatma komut dosyaları.
Geliştirme:
Systemd veya init komut dosyaları kullanarak Flutter uygulamasını başlangıçta otomatik olarak başlatmak için sistemi yapılandırın.
Uygulamanın masaüstü ortamına kullanıcı erişimini engelleyen kiosk modunda çalışmasını sağlayın.
Kullanıcı müdahalesi olmadan Flutter uygulamasının her zaman başlatıldığını doğrulamak için farklı önyükleme senaryolarını (güç döngüsü, yeniden başlatma) test edin.
Flutter Uygulaması için OTA (Kablosuz) Güncelleme Mekanizması

Araştırma Konuları:
Raspbian'da OTA güncellemelerini uygulama stratejileri.
Başarısız veya eksik güncellemelerden korunma (geri alma mekanizmaları, sürüm kontrolü).
Geliştirme:
rsync, scp veya özel güncelleme komut dosyaları kullanarak Flutter uygulamasını ağ üzerinden güncellemek için güvenli ve güvenilir bir yöntem uygulayın.
Başarısız bir güncelleme durumunda önceki sürüme geri dönen bir geri alma mekanizması tasarlayın.
Güvenilirliklerini sağlamak için güncelleme ve geri alma prosedürlerini test edin.
Raspberry Pi OS'yi Güvenli Hale Getirme

Araştırma Konuları:
Üretim ortamlarında Raspberry Pi OS'yi güvenli hale getirme en iyi uygulamaları.
Yetkisiz erişimi önlemek için işletim sistemini kilitleme yöntemleri.
Geliştirme:
Kullanılmayan hizmetleri devre dışı bırakarak ve erişimi güvenli hale getirerek (SSH, dosya izinleri, vb.) işletim sistemini sertleştirin.
Gereksiz ağ portlarını ve hizmetlerini engellemek için bir güvenlik duvarı (örneğin, ufw) yapılandırın.
Güvenli SSH erişimi (örneğin, genel anahtar doğrulaması, root oturum açmasını devre dışı bırakma) ayarlayın.
Dosya Sistemi Optimizasyonu ve Yönetimi

Araştırma Konuları:
SD kartlar için dosya sistemi performansını optimize etme stratejileri.
Günlük döndürme ve veri yönetimi teknikleri.
Geliştirme:
Büyük miktarda günlük verilerini işlemek ve disk alanı boşaltmak için günlük döndürme uygulayın.
SD kart üzerindeki okuma/yazma işlemlerini optimize ederek aşınmayı önleyin.
Dosya sistemi alanını izleyin ve yönetin, günlüklerin sistemin depolama alanı tükenmesine neden olmamasını sağlayın.
Pil Yedeklemesiyle Zaman Tutma (RTC Kurulumu)

Araştırma Konuları:
Raspberry Pi üzerinde zaman tutmak için RTC modüllerini yapılandırma.
Zaman senkronizasyon stratejileri (NTP sunucuları).
Geliştirme:
Güç kesintilerinde zaman takibini sağlamak için RTC'yi yapılandırın.
Raspberry Pi çevrimiçi olduğunda NTP sunucuları ile zaman senkronizasyonu ayarlayın.
Yeniden başlatmalar ve çevrimdışı senaryolar boyunca güvenilir zaman tutmayı sağlayın.
Çevrimdışı Mod ve Yerel Depolama Yönetimi

Araştırma Konuları:
Veri bütünlüğünü korurken çevrimdışı işlemleri ele almak için işletim sistemi ortamlarını tasarlama.
Sistem çevrimiçi hale geldiğinde veri ve günlüklerin senkronizasyonu.
Geliştirme:
Tüm verileri ve günlükleri yerel dosya sistemine kaydederek işletim sisteminin tam çevrimdışı modunu destekleyin.
Pi internet bağlantısına yeniden bağlandığında günlükleri, yapılandırmaları ve diğer verileri merkezi sunucuyla senkronize etmek için mekanizmalar oluşturun.
Günlük Sistem Yönetimi

Araştırma Konuları:
Kaynak sınırlı ortamlarda günlük dosyalarını yönetme ve depolamanın teknikleri.
Günlükleri uzak bir sunucuya gönderme ve eski günlükleri temizleme yöntemleri.
Geliştirme:
/logfolder/year/month/day/logfile1.json yapısından günlük dosyalarını periyodik olarak toplamak için bir süreç uygulayın.
Cihaz internet bağlantısına bağlı olduğunda bu günlükleri bir sunucuya göndermek için güvenli ve verimli bir yöntem tasarlayın.
Başarılı iletimden sonra veya depolama alanı azaldığında eski günlükleri silmek için otomatik günlük temizliği uygulayın.
Performans için günlük sistemini test edin, çevrimdışı ve çevrimiçi senaryolar sırasında sorunsuz çalıştığından emin olun.
Performans İzleme ve Optimizasyon

Araştırma Konuları:
Sistem performansını (CPU, bellek, ağ kullanımı) izleme araçları.
Raspberry Pi ortamında kaynak kullanımını optimize etme stratejileri.
Geliştirme:
CPU, bellek ve G/Ç kullanımını izlemek için htop veya sar gibi izleme araçlarını ayarlayın.
Sistem sağlığını otomatik olarak izleyen ve performans verilerini kaydeden komut dosyaları uygulayın.
Flutter uygulamasının sorunsuz çalışmasını sağlamak için düşük kaynak tüketimi için sistemi optimize edin.
Otomatik Yedeklemeler ve Veri Kurtarma

Araştırma Konuları:
Raspberry Pi için yedekleme çözümleri (yerel ve bulut tabanlı).
Veri kaybı veya sistem bozulması için felaket kurtarma süreçleri.
Geliştirme:
Günlükler ve yapılandırma dosyaları dahil olmak üzere önemli veriler için otomatik yedeklemeler uygulayın.
Yedeklilik için bulut tabanlı yedeklemeler için seçenekler keşfedin.
Bozulma veya arıza durumunda sistemi yedeklemelerden geri yükleyebilecek bir kurtarma mekanizması geliştirin.
Kitle Dağıtımı İçin OS Görüntüsü Özelleştirmesi

Araştırma Konuları:
Raspberry Pi birimlerinin kitlesel dağıtımı için özel OS görüntüsü oluşturma.
Flutter uygulaması, hizmetler ve güvenlik önlemleriyle önceden yapılandırma.
Geliştirme:
Önceden yüklenmiş tüm gerekli yapılandırmalar, uygulamalar ve hizmetlerle özelleştirilmiş bir Raspbian OS görüntüsü oluşturun.
Üretimde hızlı dağıtım için bu görüntüyü birden fazla Raspberry Pi birimine kopyalamak için bir klonlama işlemi geliştirin.





Backend Ekibi Görevi #1: Cihaz Aktivasyonu İçin API
Açıklama:

Backend Ekibi, her Raspberry Pi'nin ilk bağlantıda kendini etkinleştirmesine izin veren bir API oluşturmaktan sorumludur. Bu süreç, sunucuda bir cihaz kimliği oluşturarak, Pi ve backend arasındaki gelecekteki iletişimi sağlar.

Araştırma ve Geliştirme Çalışmaları:

Cihaz Aktivasyon Akışı

Araştırma Konuları:
IoT sistemleri için cihaz kayıt ve aktivasyon yöntemleri.
Cihaz aktivasyonu için güvenli token oluşturma ve doğrulama.
Geliştirme:
Cihaz ayrıntılarını (örneğin, seri numarası, cihaz kimliği) kabul eden ilk aktivasyon için bir API uç noktası tasarlayın.
Her Raspberry Pi'ye benzersiz bir kimlik atayan token tabanlı cihaz kaydı uygulayın.
Cihaz ve sunucu iletişimini korumak için TLS/SSL kullanarak aktivasyon sürecini güvenli hale getirin.
Token Oluşturma ve Atama

Araştırma Konuları:
JWT (JSON Web Token) oluşturma ve güvenli API kimlik doğrulaması için en iyi uygulamalar.
Geliştirme:
Başarılı cihaz aktivasyonu üzerine bir JWT oluşturun.
Bu tokenı, gelecekteki API etkileşimleri için güvenli iletişim sağlamak üzere Raspberry Pi'ye atayın.
Sürekli güvenlik sağlamak için tokenlar için sonlanma ve yenileme mantığı uygulayın.
Cihaz Kayıtları İçin Veritabanı Entegrasyonu

Araştırma Konuları:
Backend veritabanında cihaz kayıtlarını (örneğin, kimlik, aktivasyon tarihi, durum) depolamak.
Geliştirme:
Etkinleştirilmiş Raspberry Pi cihazlarını, durumları ve meta verileri izlemek için tablolar ekleyin.
Cihazların etkinleştirilmesi ve sistemle etkileşim halindeyken verimli bir şekilde sorgulama ve güncelleme sağlayın.
Backend Ekibi Görevi #2: Kullanıcı Oturum Açma ve JWT Token Kimlik Doğrulaması
Açıklama:

Backend Ekibi, kullanıcıların kendilerini doğrulamasına ve bir JWT tokenı almasına izin veren güvenli bir oturum açma API'si sağlamalıdır. Bu token, Raspberry Pi ve Flutter uygulaması tarafından tüm gelecekteki API iletişimi için kullanılacaktır.

Araştırma ve Geliştirme Çalışmaları:

Kullanıcı Oturum Açma İçin API

Araştırma Konuları:
Güvenli kimlik doğrulama akışları (örneğin, OAuth2, JWT tabanlı kimlik doğrulama).
Geliştirme:
Kullanıcı kimlik bilgilerini (kullanıcı adı, parola) doğrulayan ve bir JWT tokenı oluşturan bir oturum açma API'si oluşturun.
Kullanıcı kimlik bilgilerini güvenli bir şekilde depolamak için (örneğin, bcrypt kullanarak parola karmaşası) oturum açma API'sini kullanıcı veritabanı ile entegre edin.
Başarısız oturum açmaları için uygun hata işleme ayarlayın (örneğin, birden fazla başarısız girişimden sonra hesap engelleme).
JWT Token Oluşturma ve Doğrulama

Araştırma Konuları:
JWT tokenı oluşturma, doğrulama ve sonlanma için en iyi uygulamalar.
Geliştirme:
Oturum açma sırasında sonlanma süreleri ve yenileme mekanizmalarıyla birlikte token çıkışı uygulayın.
Devam eden API kullanımı için tokenları Raspberry Pi üzerinde güvenli bir şekilde saklayın.
Flutter uygulamasından gelecekteki API çağrılarını yetkilendirmek için bir token doğrulama sistemi oluşturun.
Kullanıcı Rol Yönetimi ve Erişim Kontrolü

Araştırma Konuları:
Kullanıcılar için rol tabanlı erişim kontrolü (RBAC) (örneğin, yönetici, düzenli kullanıcı).
Geliştirme:
Backend'de kullanıcı rollerini tanımlayın ve API uç noktalarının rollerine göre erişim kısıtlamalarına uymasını sağlayın.
JWT iddialarına rol yönetimini entegre edin, uygulamanın farklı kullanıcı rollerine göre farklı UI veya işlevsellik uygulayabilmesini sağlayın.
Backend Ekibi Görevi #3: Günlük Senkronizasyon API'si
Açıklama:

Backend, Raspberry Pi cihazlarının (Flutter uygulaması ve OS ekibi komut dosyaları) periyodik olarak günlükler göndermesine izin veren bir API sağlamalıdır. Backend, bu günlükleri verimli bir şekilde depolamak ve analiz için erişilebilir hale getirmekten sorumlu olacaktır.

Araştırma ve Geliştirme Çalışmaları:

Günlük Senkronizasyon API Tasarımı

Araştırma Konuları:
Bir IoT ortamında büyük günlük dosyaları veya günlük akışlarını ele almak için en iyi uygulamalar.
JSON günlüklerini verimli bir şekilde alıp depolamak için stratejiler.
Geliştirme:
Raspberry Pi cihazlarından günlük dosyaları kabul eden bir API uç noktası tasarlayın. Günlükler /logfolder/year/month/day/logfile1.json gibi bir yapı izleyecektir.
Birden fazla cihazın aynı anda günlükler senkronize etmesini sağlamak için büyük günlük gruplarını işleme mekanizmaları uygulayın.
Gerekirse günlüklerin yeniden gönderilebilmesini sağlamak için başarısız yüklemeler için hata işleme ayarlayın.
Günlük Depolama ve Veritabanı Tasarımı

Araştırma Konuları:
Günlük depolama çözümleri (örneğin, zaman serisi veritabanları, dosya tabanlı depolama sistemleri).
Depolama boyutunu küçültmek için günlük verileri için sıkıştırma teknikleri.
Geliştirme:
Zaman, cihaz ve günlük türüne göre verimli sorgulama desteği sağlayan günlükler için ölçeklenebilir bir depolama çözümü uygulayın.
Belirli bir süre sonra eski günlükleri arşivleme veya silme gibi veri tutma politikaları oluşturun.
Birden fazla cihazdan sık sık günlüğün yüklenmesi nedeniyle yazma yoğun işlemler için veritabanını optimize edin.
Günlük Alımı ve Raporlama

Araştırma Konuları:
Günlük analizi için sorgulama ve raporlama araçları.
Gerçek zamanlı olarak günlükleri izlemek için panolar veya görselleştirme araçları.
Geliştirme:
Sistem yöneticileri veya geliştiriciler için günlükleri alıp görselleştirmek üzere API'ler veya arayüzler oluşturun.
Kolay sorun giderme ve analiz için günlük erişiminin cihaz, tarih ve olay türüne göre filtrelenebilmesini sağlayın.
Gelişmiş analiz için üçüncü taraf günlük görselleştirme platformları (örneğin, ELK Stack, Grafana) ile entegrasyon keşfedin.




Flutter Ekibi: Ana Görevler Genel Bakışı
Görev #1: Flutter Uygulaması Çekirdek Geliştirmesi

Raspberry Pi üzerinde çalışan uygulama, kullanıcı arayüzü ve çekirdek işlevlerini oluşturmak.
Kullanıcı hesap oluşturma, bölge ve cihaz yönetimi ve cihaz durumlarını ve komutlarını kontrol etmek için kontrol döngüsünü ele almak.
Raspberry Pi'nin sınırlı kaynakları üzerinde sorunsuz ve duyarlı performans sağlamak.
Görev #2: GPIO ve Seri İletişim Entegrasyonu

Cihazları GPIO ve seri iletişim yoluyla kontrol etmek için mantık geliştirmek.
Bağlı cihazlar için Raspberry Pi'nin GPIO pinleri ve UART arayüzünden girişleri ve çıkışları yönetmek.
Görev #3: Haftalık Plan ve Sıcaklık Yönetimi

Cihaz eylemlerini haftalık bir plana ve sıcaklık verilerine göre planlamak için mantık uygulamak.
Sensör verilerini ele almak, zaman ve koşulları değerlendirmek ve buna göre cihazlara komutlar göndermek.
Görev #4: Kullanıcı Arayüzü (UI) Tasarımı ve Kullanıcı Deneyimi (UX)

Bölgeleri, cihazları kontrol etmek ve durumu görüntülemek için temiz, sezgisel bir kullanıcı arayüzü oluşturmak.
Cihaz ekleme, bölge yönetimi ve haftalık planlar ayarlamak için ekranlar uygulamak.
Görev #5: SQLite ile Yerel Veri Yönetimi

Bölgeler, cihazlar ve kullanıcı ayarları için SQLite kullanarak yerel depolama uygulamak.
UI eylemleri ve veritabanı değişiklikleri arasında veri bütünlüğü ve senkronizasyon sağlamak.
Görev #6: Günlük Sistem Entegrasyonu

Olayları ve durum değişikliklerini JSON formatında kaydetmek için işlevsellik eklemek.
Günlüklerin /logfolder/year/month/day/logfile1.json yapısını izlediğinden ve OS ekibi tarafından erişilebilir olduğundan emin olmak.
Görev #7: Kimlik Doğrulama API Entegrasyonu

İlk cihaz aktivasyonu ve kullanıcı oturum açması için JWT aracılığıyla uygulamayı backend'e bağlamak.
JWT tokenlarının düzgün şekilde işlenmesini ve backend sunucusu ile güvenli iletişim sağlamak.
Flutter Görevi #1: Flutter Uygulaması Çekirdek Geliştirmesi
Bu görev, Raspberry Pi üzerinde çalışan uygulamanın çekirdek mimarisini oluşturmaya, sorunsuz çalışma, duyarlı performans ve temel özelliklerin entegrasyonuna odaklanır.

Alt Görev #1: Proje Kurulumu ve Yapılandırması

Açıklama:
Raspberry Pi için özelleştirilmiş Flutter projesini kurmak, Pi'nin donanım kaynakları (örneğin, dokunmatik ekran) ile kullanılması için yapılandırmak.
Adımlar:
Flutter ortamını Raspberry Pi için kurun, ARM mimarisini desteklediğinden emin olun.
Raspberry Pi donanımı için optimum performans için proje ayarlarını yapılandırın.
Uygulamanın Raspberry Pi OS'de önyükleme sırasında başlatıldığından emin olun.
Verimli geliştirme için hızlı yeniden yükleme veya uzak hata ayıklama araçları ayarlayın.
Alt Görev #2: Uygulama Mimarisi Tasarımı

Açıklama:
Ölçeklenebilirlik ve endişelerin temiz bir şekilde ayrılmasını (örneğin, kontrolörler, hizmetler, UI) destekleyen uygulamanın mimari yapısını tanımlamak.
Adımlar:
Durum yönetimi çözümüne karar verin (örneğin, Provider, Riverpod, Bloc).
Cihaz işlemleri, GPIO/seri iletişim, veri depolaması ve günlük yönetimi için hizmet sınıfları oluşturun.
Modüler tasarımla uygulama yapısı: kodu kontrolörler, hizmetler, modeller ve UI bileşenlerine ayırın.
7" dokunmatik ekran görüntüsüne uyan duyarlı bir tasarım sağlayın.
Alt Görev #3: Kontrol Döngüsü Uygulaması

Açıklama:

Her saniye cihaz durumlarını, haftalık plan programlarını, sıcaklıkları kontrol etmek ve koşullara göre komutlar tetiklemek için çalışan çekirdek kontrol döngüsünü geliştirin. Bu döngü ayrıca bir acil durum GPIO giriş pinini izlemeli ve bir alarm tetiklenirse (örneğin, yangın), sistem tüm bağlı cihazları derhal kapatmalıdır.

Adımlar:

Kontrol Döngüsü İçin Zamanlayıcı Uygulaması

Her saniye kontrol döngüsünü çalıştıran bir arka plan hizmeti veya periyodik zamanlayıcı ayarlayın.
Zamanlayıcının Raspberry Pi'nin donanımı için hafif ve verimli olduğundan emin olun.
SQLite Veritabanını Sorgula

Cihaz yapılandırmaları, cihaz eşlemeleri, haftalık planlar ve sensör verilerini SQLite'dan alın.
Verilerin her zaman güncel olduğundan ve kullanıcı değişikliklerini hemen yansıttığından emin olun.
Cihaz Durumlarını ve Sensör Verilerini İzle

Cihaz durumlarını GPIO ve seri iletişim yoluyla sürekli kontrol edin.
Karar verme için doğru gerçek zamanlı veriler sağlamak üzere sıcaklık sensörlerini okuyun.
Haftalık Planı ve Koşulları Değerlendir

Her cihaz için mevcut zamanı ve tarihi haftalık planla karşılaştırın.
Cihazın açılıp kapatılması gerektiğini belirlemek için sıcaklık okumalarını ve diğer ilgili verileri kontrol edin.
Koşullar karşılanırsa (örneğin, belirli sıcaklıklar ulaştı, zaman planlandı), cihazlara kontrol etmek için uygun GPIO/seri komutları gönderin.
Acil Durum Girişi Pinini İzleme

Acil durum sinyalleri (örneğin, yangın alarmları) için ayrılmış GPIO giriş pinini izleyin.
Tetikleme Üzerine Eylem:
Alarm girişi tetiklenirse, kontrol döngüsündeki diğer tüm mantığı hemen geçersiz hale getirin.
Tüm bağlı cihazları (örneğin, ısıtıcılar, soğutucular, kapılar, ışıklar) kapatmak için bir kapatma dizisi çalıştırın, GPIO ve seri iletişim yoluyla komutlar gönderin.
Sistemin manuel olarak sıfırlanana veya alarm girişi devre dışı bırakılana kadar bu acil durum modunda kaldığından emin olun.
GPIO ve Seri Aracılığıyla Komutlar Gönder

Değerlendirilen koşullara (haftalık plan, sensör verileri, acil durum girişi) göre, bağlı cihazlara uygun GPIO sinyalleri veya UART komutları gönderin.
Güvenilir iletişim sağlayın ve başarısız komutlar veya bağlantı sorunları durumunda hata işleme uygulayın.
Olayları Günlükleyin

Cihaz kontrolü, hatalar ve acil durum kapatma tetikleyicileri gibi tüm olayları günlükleyin.
Bu günlüklerin OS ekibi tarafından daha fazla işleme için alınabilmesi için /logfolder/year/month/day/logfile.json standardı JSON formatını izlediğinden emin olun.
Hata İşleme

Geçici iletişim veya veri alma hataları durumunda bile döngünün devam etmesini sağlamak için sağlam hata işleme uygulayın.
Sensör veya cihaz iletişim hatalarını kapsayarak hata mesajları kaydedin ve yeniden deneme girişimleri yapın.
Alt Görev #4: Bölge ve Cihaz Yönetimi Mantığı
Açıklama:
Cihazları GPIO pinlerine veya seri komutlarına eşleyerek bölgeler, cihazlar ekleme, güncelleme ve kaldırma işlevlerini ele alın.
Adımlar:
Bölgeleri ekleme, düzenleme ve silme için UI ekranları tasarlayın.
Kullanıcıların cihazları bölgelere atamasına izin veren cihaz ekleme mantığı uygulayın.
Cihazları GPIO pinlerine veya seri uzatma kartlarına bağlamak için bir eşleme sistemi oluşturun.
Kullanıcılar tarafından yapılan değişikliklerin gerçek zamanlı olarak yerel SQLite veritabanını güncellediğinden emin olun.
Doğrulama kontrolleri oluşturun (örneğin, benzersiz cihaz adları sağlayın, yinelenen GPIO atama işlemlerini önleyin).
Alt Görev #5: Hata İşleme ve Kurtarma

Açıklama:
Cihaz kontrolü, veri alma veya sistem durumu kontrolleri ile ilgili çeşitli potansiyel sorunlar için hata işleme ve kurtarma uygulayın.
Adımlar:
Cihaz kontrolü, veri alma ve sistem durumu kontrolleri ile ilgili hataları yakalamak ve günlüklemek için mekanizmalar geliştirin.
Cihazlarla iletişim hatası durumunda yedek stratejileri uygulayın.
Kullanıcıları UI aracılığıyla sistem hataları konusunda bilgilendirin ve kritik hataların günlük sisteminde kaydedildiğinden emin olun.
Alt Görev #6: Çevrimdışı Mod

Açıklama:
İlk kullanıcı hesabı kurulumu tamamlandıktan sonra uygulamanın tamamen çevrimdışı çalışmasını sağlayın. Uygulamanın tüm işlevselliğini (bölge yönetimi, cihaz kontrolü ve planlama) sunucu bağlantısı olmadan koruyun.
Adımlar:
Kullanıcı verilerinin, bölge ayarlarının ve cihaz planlarının tamamının SQLite'da yerel olarak depolandığından emin olun.
Sunucu iletişiminin yokluğunda günlük senkronizasyonu veya OTA güncellemeleri gibi API'ye bağımlı özelliklerin ertelenmesini sağlayın.
Cihaz kontrol işlevselliğini kesintiye uğratmadan sunucu iletişiminin yokluğunu zarif bir şekilde ele almak için yöntemler geliştirin.
Alt Görev #7: Güç Yönetimi ve Başlatma/Durdurma Prosedürleri

Açıklama:
Uygulamanın güç açma, kapatma veya yeniden başlatma sırasında nasıl davrandığını yönetin, yeniden başlatmadan sonra cihaz durumlarının doğru şekilde geri yüklenmesini sağlayın.
Adımlar:
Uygulama başladığında önceki cihaz durumlarını SQLite'dan alıp hemen uygulayan bir başlatma prosedürü oluşturun.
Devam eden cihaz komutlarını güvenli bir şekilde kaydeden ve durduran bir kapatma mantığı uygulayın.
Raspberry Pi önyüklemesinde uygulamanın otomatik olarak başlatılmasını sağlamak için OS ekibiyle birlikte çalışın.
Flutter Görevi #8: Kurulum Süreci Uygulaması
Açıklama:

Raspberry Pi için ilk kurulum sürecini geliştirerek, kullanıcıların cihazı temel ayarlarla yapılandırmasına ve müşteri hesabı aracılığıyla etkinleştirmesine olanak tanıyın. Bu süreç ayrıca cihaz üzerindeki hesapları (Teknik Destek, Yönetici) oluşturmayı ve sistemin çalışma parametrelerini ayarlamayı içerir.

Adımlar:

Dil Seçimi Ekranı

Kullanıcıların uygulama için tercih ettikleri dili seçmelerine izin veren bir ekran geliştirin.
Dil tercimini yerel olarak kaydedin ve tüm UI'ye uygulayın.
Zaman Dilimi Seçimi Ekranı

Zaman dilimi seçimi için bir ekran uygulayın.
Seçilen zaman diliminin uygulama genelinde tarih/zaman işlevlerine uygulandığından emin olun.
Tarih-Zaman Görünümü Seçimi

Kullanıcılara farklı tarih-zaman formatları (örneğin, 24 saatlik veya 12 saatlik saat) arasında seçim yapma seçeneği sunun.
Bu ayarı uygulama genelinde uygulamak için mantık uygulayın.
Ağ Bağlantısı (Wi-Fi/Ethernet)

Wi-Fi veya Ethernet bağlantısı kurulumu için UI oluşturun.
Kullanıcıların bağlantı için kimlik bilgilerini girmesine izin vermek üzere mevcut Wi-Fi ağlarını aramak için işlemi entegre edin.
Başarısız bağlantı ve yeniden bağlantı girişimleri için hata işleme uygulayın.
Cihaz Kaydı

Raspberry Pi hakkında gerekli bilgileri (örneğin, cihaz kimliği, donanım ayrıntıları) otomatik olarak toplayın.
Cihaz kaydı için bu bilgileri API aracılığıyla backend sunucusuna gönderin.
Müşteri Oturum Açma (Bulut Hesabı)

Kullanıcının bulut hesabında (müşteri hesabı) oturum açması için bir giriş ekranı oluşturun.
Başarılı oturum açma üzerine JWT tokenı alarak kullanıcı kimlik doğrulaması uygulayın.
"hesap oluştur" ve "parola unutuldu" seçeneklerini entegre edin.
Abonelik Durumu Kontrolü

Oturum açmadan sonra, kullanıcının abonelik durumunu almak için bir API çağrısı yapın.
Abonelik durumuna göre uygulamada herhangi bir kısıtlama (örneğin, ücretsiz hesaplar için sınırlı bölgeler/cihazlar) uygulayın.
Cihaz Aktivasyonu

Başarılı kayıt ve abonelik kontrolünden sonra, Raspberry Pi'yi API çağrısı aracılığıyla etkinleştirmek için mantık uygulayın.
Cihazın etkinleştirme durumunun yerel olarak depolandığından ve gelecekteki kullanım için alınabildiğinden emin olun.
Teknik Destek Hesabı Oluşturma

Cihazın teknik yönetimi için kullanıcıyı Teknik Destek hesabı oluşturmaya yönlendirin.
Hesap kimlik bilgilerini yerel olarak kaydedin ve uygulamada uygun erişim seviyelerinin uygulandığından emin olun.
Yönetici Hesabı Oluşturma

Cihaz ayarları ve kullanıcı yönetimi için daha geniş erişime sahip olacak bir Yönetici hesabı oluşturmak için bir akış geliştirin.
Gerektiğinde kullanıcıların ek standart hesaplar eklemesine izin verin.
Tema Seçimi (Açık/Koyu/Sistem)
Kullanıcılara açık, koyu veya sistem temaları arasında seçim yapma seçeneği sunun.
Tema seçiminin uygulamanın UI'sine tutarlı bir şekilde uygulandığından emin olun.
Hoşgeldin/Öğretici Ekranları
Kullanıcılara sistemin temel özelliklerini (bölgeler, cihazlar, kontrol seçenekleri) tanıtan bir hoşgeldin ekranı ve kısa bir öğretici geçişi geliştirin.
