<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use App\Models\Team;
class TeamsTableSeeder extends Seeder
{
    public function run(): void
    {
         $teams = [
            // الدوري الإسباني
            ['name' => 'ريال مدريد', 'logo_url' => 'logos/real-madrid.png'],
            ['name' => 'برشلونة', 'logo_url' => 'logos/barcelona.png'],
            ['name' => 'أتلتيكو مدريد', 'logo_url' => 'logos/atletico-madrid.png'],
            ['name' => 'إشبيلية', 'logo_url' => 'logos/sevilla.png'],
            ['name' => 'فالنسيا', 'logo_url' => 'logos/valencia.png'],
            ['name' => 'فياريال', 'logo_url' => 'logos/villarreal.png'],
            ['name' => 'ريال بيتيس', 'logo_url' => 'logos/real-betis.png'],
            ['name' => 'ريال سوسيداد', 'logo_url' => 'logos/real-sociedad.png'],
            ['name' => 'أتلتيك بيلباو', 'logo_url' => 'logos/athletic-bilbao.png'],
            
            // الدوري الإنجليزي
            ['name' => 'مانشستر يونايتد', 'logo_url' => 'logos/man-utd.png'],
            ['name' => 'مانشستر سيتي', 'logo_url' => 'logos/man-city.png'],
            ['name' => 'ليفربول', 'logo_url' => 'logos/liverpool.png'],
            ['name' => 'تشيلسي', 'logo_url' => 'logos/chelsea.png'],
            ['name' => 'أرسنال', 'logo_url' => 'logos/arsenal.png'],
            ['name' => 'توتنهام هوتسبر', 'logo_url' => 'logos/tottenham.png'],
            ['name' => 'نيوكاسل يونايتد', 'logo_url' => 'logos/newcastle.png'],
            ['name' => 'وست هام يونايتد', 'logo_url' => 'logos/west-ham.png'],
            ['name' => 'إيفرتون', 'logo_url' => 'logos/everton.png'],
            ['name' => 'أستون فيلا', 'logo_url' => 'logos/aston-villa.png'],
            
            // الدوري الإيطالي
            ['name' => 'يوفنتوس', 'logo_url' => 'logos/juventus.png'],
            ['name' => 'إنتر ميلان', 'logo_url' => 'logos/inter.png'],
            ['name' => 'ميلان', 'logo_url' => 'logos/milan.png'],
            ['name' => 'نابولي', 'logo_url' => 'logos/napoli.png'],
            ['name' => 'روما', 'logo_url' => 'logos/roma.png'],
            ['name' => 'لاتسيو', 'logo_url' => 'logos/lazio.png'],
            ['name' => 'أتالانتا', 'logo_url' => 'logos/atalanta.png'],
            ['name' => 'فيورنتينا', 'logo_url' => 'logos/fiorentina.png'],
            
            // الدوري الألماني
            ['name' => 'بايرن ميونخ', 'logo_url' => 'logos/bayern.png'],
            ['name' => 'بوروسيا دورتموند', 'logo_url' => 'logos/dortmund.png'],
            ['name' => 'باير ليفركوزن', 'logo_url' => 'logos/leverkusen.png'],
            ['name' => 'لايبزيغ', 'logo_url' => 'logos/leipzig.png'],
            ['name' => 'آينتراخت فرانكفورت', 'logo_url' => 'logos/frankfurt.png'],
            ['name' => 'بوروسيا مونشنجلادباخ', 'logo_url' => 'logos/gladbach.png'],
            ['name' => 'فولفسبورغ', 'logo_url' => 'logos/wolfsburg.png'],
            ['name' => 'شالكه 04', 'logo_url' => 'logos/schalke.png'],
            
            // الدوري الفرنسي
            ['name' => 'باريس سان جيرمان', 'logo_url' => 'logos/psg.png'],
            ['name' => 'موناكو', 'logo_url' => 'logos/monaco.png'],
            ['name' => 'مارسيليا', 'logo_url' => 'logos/marseille.png'],
            ['name' => 'ليون', 'logo_url' => 'logos/lyon.png'],
            ['name' => 'ليل', 'logo_url' => 'logos/lille.png'],
            ['name' => 'نيس', 'logo_url' => 'logos/nice.png'],
            ['name' => 'رين', 'logo_url' => 'logos/rennes.png'],
            
            // الدوري البرتغالي
            ['name' => 'بنفيكا', 'logo_url' => 'logos/benfica.png'],
            ['name' => 'بورتو', 'logo_url' => 'logos/porto.png'],
            ['name' => 'سبورتينغ لشبونة', 'logo_url' => 'logos/sporting.png'],
            
            // الدوري الهولندي
            ['name' => 'أياكس', 'logo_url' => 'logos/ajax.png'],
            ['name' => 'آيندهوفن', 'logo_url' => 'logos/psv.png'],
            ['name' => 'فينورد', 'logo_url' => 'logos/feyenoord.png'],
            
            // فرق عربية
            ['name' => 'الهلال', 'logo_url' => 'logos/al-hilal.png'],
            ['name' => 'النصر', 'logo_url' => 'logos/al-nassr.png'],
            ['name' => 'الأهلي', 'logo_url' => 'logos/al-ahli.png'],
            ['name' => 'الاتحاد', 'logo_url' => 'logos/al-ittihad.png'],
            ['name' => 'الزمالك', 'logo_url' => 'logos/el-zamalek.png'],
            ['name' => 'الأهلي المصري', 'logo_url' => 'logos/al-ahly-egypt.png'],
            ['name' => 'الرجاء', 'logo_url' => 'logos/raja.png'],
            ['name' => 'الوداد', 'logo_url' => 'logos/wydad.png'],
            
            // فرق أوروبية إضافية
            ['name' => 'سلتيك', 'logo_url' => 'logos/celtic.png'],
            ['name' => 'رينجرز', 'logo_url' => 'logos/rangers.png'],
            ['name' => 'غلطة سراي', 'logo_url' => 'logos/galatasaray.png'],
            ['name' => 'فنربخشة', 'logo_url' => 'logos/fenerbahce.png'],
            ['name' => 'بشكتاش', 'logo_url' => 'logos/besiktas.png'],
            ['name' => 'شاختار دونيتسك', 'logo_url' => 'logos/shakhtar.png'],
            ['name' => 'دينامو كييف', 'logo_url' => 'logos/dynamo-kyiv.png'],
            
            // فرق أمريكية
            ['name' => 'لوس أنجلوس جلاكسي', 'logo_url' => 'logos/la-galaxy.png'],
            ['name' => 'إنتر ميامي', 'logo_url' => 'logos/inter-miami.png'],
            ['name' => 'نيويورك سيتي', 'logo_url' => 'logos/nyc.png'],
            
            // منتخبات وطنية (إذا تريد)
            ['name' => 'الأرجنتين', 'logo_url' => 'logos/argentina.png'],
            ['name' => 'البرازيل', 'logo_url' => 'logos/brazil.png'],
            ['name' => 'فرنسا', 'logo_url' => 'logos/france.png'],
            ['name' => 'إنجلترا', 'logo_url' => 'logos/england.png'],
            ['name' => 'ألمانيا', 'logo_url' => 'logos/germany.png'],
            ['name' => 'إيطاليا', 'logo_url' => 'logos/italy.png'],
            ['name' => 'إسبانيا', 'logo_url' => 'logos/spain.png'],
            ['name' => 'المغرب', 'logo_url' => 'logos/morocco.png'],
            ['name' => 'مصر', 'logo_url' => 'logos/egypt.png'],
            ['name' => 'السعودية', 'logo_url' => 'logos/saudi-arabia.png'],
        ];

 
    echo "حذف الفرق القديمة...\n";
    DB::table('teams')->delete();
    DB::statement('ALTER TABLE teams AUTO_INCREMENT = 1');
    
    echo "بدء الإضافة...\n";
    
    $batchSize = 20;
    $total = count($teams);
    
    for ($i = 0; $i < $total; $i += $batchSize) {
        $batch = array_slice($teams, $i, $batchSize);
        $batchData = [];
        
        foreach ($batch as $team) {
            $batchData[] = [
                'name' => $team['name'],
                'logo_url' => $team['logo_url'],
                'created_at' => now(),
                'updated_at' => now(),
            ];
        }
        
        try {
            DB::table('teams')->insert($batchData);
            echo " تمت إضافة الدفعة " . (($i/$batchSize)+1) . " (" . count($batch) . " فريق)\n";
        } catch (\Exception $e) {
            echo " خطأ في الدفعة: " . $e->getMessage() . "\n";
            // حاول إضافة فرق فردياً
            foreach ($batch as $team) {
                try {
                    DB::table('teams')->insert([
                        'name' => $team['name'],
                        'logo_url' => $team['logo_url'],
                        'created_at' => now(),
                        'updated_at' => now(),
                    ]);
                } catch (\Exception $e2) {
                    echo " فشل إضافة: {$team['name']} - " . $e2->getMessage() . "\n";
                }
            }
        }
    }
    
    echo "\n✅ اكتملت العملية\n";
    echo "العدد الكلي: " . DB::table('teams')->count() . " فريق\n";
}

}