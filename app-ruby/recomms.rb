require 'narray'
require 'logger'
require 'redis'
require 'memcached'
require_relative 'models/init'
  
class Recomms
 
  def initialize()
    @log = Logger.new(STDOUT)
    @log.level = Logger::DEBUG
  end 

  def getScores(steamid, reportItems)
    games = getOwnedGames(steamid).map { |item| item.to_s }
    getColumnsFromRedis(games)
    getColumnsFromMySQL(games)
    getColumnsFromMemcached(games)
  end

  private
  def getOwnedGames(steamid)
    #['440', '104700', '218980', '205080', '1630', '19800']
    [4400,0,8800,17600,22000,44000,13140,47830,61220,70400,213650,105100,4410,10,61230,221430,244870,218020,47810,13120,218040,70420,20,205870,237310,21990,221410,233410,26300,30,56400,21970,202570,233470,65080,205840,225760,40,47870,21980,233450,50,8790,47850,91310,221380,210230,205830,60,8740,205950,4470,70,218090,233370,21950,17550,202530,39160,221360,91330,39140,21920,205930,80,92,61310,4460,65100,221340,35300,218060,21910,100,70500,39120,17570,205910,35310,17580,47800,47780,233390,105200,39110,4420,95700,47790,21900,35320,17480,225600,4540,221300,202730,4530,8930,130,47700,4520,8955,17500,13250,202750,95500,202690,217860,105000,225640,65200,47730,17510,210350,4500,17530,35130,202710,17520,221260,17420,205,70600,4600,13210,202670,35140,8870,13200,17410,210390,220,237110,221220,21800,8890,70620,4580,108800,206060,217980,91200,17430,233230,8880,211,233270,221200,39000,17450,4570,13240,8840,21780,65270,206040,17440,210410,4560,65260,206020,13230,17470,70650,233250,70640,4550,210430,17460,8850,240,21760,213610,21730,39330,217790,209950,280,65300,237550,21750,260,9060,39350,9070,9040,237530,221640,4100,12900,39300,35000,9050,39310,105400,48110,217750,70200,26500,9030,39320,48120,300,202310,21670,35030,206190,340,17810,48000,105430,9010,12800,12810,91600,225420,70210,320,35010,21680,12830,21690,9000,105420,108700,17800,8980,202270,61010,39360,108710,35070,380,39370,21640,12840,39380,12860,21660,105450,360,8970,61000,65400,70300,225360,21610,13000,113020,237430,39200,400,9200,206250,21600,61100,34830,17740,17730,34820,21620,206270,440,206210,9180,43600,34870,4230,9160,206230,34860,17760,39190,420,100970,225300,105310,78000,34900,232970,4320,105300,47900,65500,225280,213850,100980,47890,202410,4300,500,210170,34930,217690,4290,210150,39260,17710,202370,65530,34920,17700,39250,480,47920,95300,225320,550,12660,8260,4880,91830,12670,65560,8270,232950,4890,22490,4870,91810,65540,12640,60700,202070,39560,12650,570,217490,8280,12630,8290,39600,8300,91800,43500,4920,39610,18120,226240,35720,22500,202110,4900,232910,8310,113400,104600,236790,206370,213120,39640,91900,12600,8200,109500,25800,96200,620,241620,8210,206410,39620,630,70000,65600,18100,12580,241600,104700,18110,12590,39630,221830,65610,8220,12560,22450,18050,39670,8230,25830,12570,25840,39650,8240,236730,206440,18070,12550,210770,25850,35800,8250,39660,206480,96000,12790,18020,221790,91700,60800,25600,22350,210870,213030,241410,18040,109410,25620,22340,12770,202200,8400,109400,65720,221810,644,226120,22380,206500,12750,65710,232770,18000,65700,22370,35600,8330,245350,70120,22300,8320,39510,65740,202130,8350,39500,765,12710,35700,232750,65730,8340,47130,65790,8360,22330,39550,22320,47120,96100,65780,12690,25700,39540,70110,39530,730,57000,8380,202170,70100,8370,47110,113200,22310,18420,35510,12390,26000,210490,65800,95900,25990,22230,12400,18400,35500,206610,222160,241320,217270,35480,12360,35460,12370,57200,47570,12380,201830,35470,57210,12320,47520,43160,12330,210550,217290,12340,47540,4700,39900,92100,22180,43190,8500,201790,206690,47500,29900,12300,236970,4720,104900,12310,222140,109200,4730,201760,22200,210500,18300,43100,12520,39690,8660,39680,39710,12540,25870,206740,4760,65950,8650,22100,25860,57300,8640,12530,217140,4780,60600,22120,25910,8690,206760,4770,12480,100410,12510,25900,22140,29720,4790,100400,43110,12500,25890,22130,8600,35450,29800,47400,12460,213350,4800,12450,25940,236830,92000,113420,25930,1002,4830,47410,60610,201870,12470,236850,232450,217200,12430,35420,25980,12420,39800,213330,12440,8620,4850,201510,29660,36300,20920,209230,226700,9760,36290,29650,29640,36310,20900,214730,9740,204880,29690,214770,243950,9730,201480,36320,29680,226740,209270,5450,201490,29670,48800,201570,113900,40120,226760,204860,29590,16600,9850,36240,64000,204840,219070,226780,40100,45000,9800,94600,209190,36270,16620,36280,94620,55370,219030,232430,214700,94610,29520,36160,9900,218980,90200,1230,36170,214610,29530,232210,36180,209370,236090,36190,94590,209360,94530,209390,9860,1250,48700,9870,36200,214640,1270,40000,36210,29550,214630,9880,94500,48720,16450,36100,94510,9960,236130,222320,36110,102200,201700,9970,106000,60340,20840,204960,36120,9980,60350,106010,94520,16480,36130,20820,214590,9930,36140,29500,1200,214570,209340,204940,9940,36150,16500,1210,214560,209330,71260,10040,40420,71250,109700,71240,218860,40390,44690,10000,218820,16810,201230,9990,71270,40400,201330,10110,1309,67370,90500,20710,205100,10100,1300,10090,40380,222710,1280,10080,239800,40370,40330,71230,25500,222660,205060,40320,90530,205070,201310,1320,201280,20700,40350,201290,214970,1313,205080,236490,36000,40340,48900,40300,218740,1500,10170,44600,226320,71390,214850,209100,10150,20530,222520,214870,20540,1525,1520,10130,10140,16700,205250,71420,1530,94300,48950,20500,214910,218700,1510,239700,205270,20510,10120,236290,222480,209120,232010,218680,16720,10230,205230,239660,16730,71320,20590,214790,71300,16710,71310,236390,218660,10220,209080,44630,214830,244030,90400,20550,236370,49000,40200,218640,205190,40210,10180,201420,20570,232050,71340,44620,10190,209060,200960,63610,1640,21400,13630,24780,29180,63600,227240,240600,52003,105700,13620,214270,235660,17080,29160,200980,110500,214250,13600,24790,200990,209790,209730,1610,6010,24810,227200,214230,40700,29150,6000,1600,24800,201000,29140,17030,214210,201010,29130,222880,235700,209750,13580,24830,227220,71000,1630,29120,13570,24820,218620,48260,201020,227300,205330,90800,29110,209710,218510,235720,17120,231910,9310,17140,227320,24720,209670,21500,17100,201070,24740,105600,214170,214150,9340,205350,63500,24760,13640,227280,209690,24640,205530,48180,9350,231740,222750,6100,24650,214130,48190,48160,6080,222730,24660,44310,6090,218450,24670,44320,227080,16900,48150,21300,209870,63700,63710,214100,205550,13700,227100,44340,6120,9400,24700,44350,36700,227180,1700,48240,9420,209830,44360,6040,6020,209850,63650,63660,6030,95000,17020,214050,24600,40500,1670,48210,218410,24610,24620,201190,48220,36620,63640,9450,9460,110400,36630,63620,24630,201210,227160,63630,6060,222820,1690,21130,209520,17340,9500,21120,17330,227000,214510,205650,9480,40920,200710,1900,218310,226980,21140,40930,17300,44200,91100,21180,21170,205690,218350,40950,17400,24980,1840,205590,17390,63800,24960,214400,25010,205610,223220,214420,70660,240200,70900,24920,21000,222980,21010,223000,205790,235780,13500,40800,63940,24950,21030,209630,231430,214340,63950,218230,17180,214360,209610,235820,63960,218210,205810,226820,105800,63910,205710,13540,24850,214310,24860,21070,218130,200910,44100,40720,200900,24840,21080,13560,214320,13510,21090,218170,21100,205730,240160,24870,21110,200940,1920,13520,9710,67000,209540,63900,240180,1930,13530,2200,50650,212370,223330,6570,200390,36910,15310,50640,238890,63110,15300,36900,15320,6590,80360,200410,99120,219950,6580,93200,80350,15330,204760,80340,212410,41800,227680,99100,238870,219910,212390,80330,2210,15350,6550,208030,2270,15240,208110,231180,33110,235070,80310,15260,33100,223280,80300,200350,110630,41760,50620,2300,32620,6600,231200,15270,110610,63200,2290,32610,41740,19500,110600,215670,63230,238930,15290,33130,2280,200370,32630,33120,41730,15280,208090,220090,32640,215690,45760,227800,15170,223470,37030,45770,32650,235250,212240,33180,200260,207930,32660,215710,15190,63000,50510,239030,32670,90100,72500,6400,15200,110800,99200,2100,37000,24010,15210,32680,33210,220050,223430,204630,32690,223450,37010,19680,15220,6420,207890,80200,15230,32700,107000,32710,45700,99300,2130,45710,37100,6510,33220,15120,215770,32720,227720,33230,204580,41900,6520,200210,15130,32730,45720,33270,215790,32740,15140,45730,32750,45740,15150,200230,227760,204560,239070,223390,45750,33250,33260,15160,32760,219680,6330,235360,11240,227400,32770,63380,200670,15060,212110,204530,19800,238630,45900,11260,230980,2450,6310,97330,15100,6300,11200,19810,32800,50400,6290,215870,32310,15080,11230,204510,231020,19830,238710,32350,11180,37240,212160,15000,204450,32340,50310,2500,11170,23600,212180,2525,37230,219760,32330,2520,11190,72400,37220,6370,223530,32380,223510,2540,200630,11150,37210,6360,11140,80000,215930,98900,37200,32370,212200,6350,227380,41500,32360,6340,212220,2550,219740,2545,204440,32400,2310,37300,32900,41700,32410,211970,200530,6200,223730,72200,204390,37310,37280,11120,2320,32390,19930,11130,2330,37290,111100,212010,231160,204360,2340,37270,223710,32440,2350,219780,37250,41680,219800,32420,212030,227580,208140,243120,2360,231140,200550,37260,32430,50300,111010,32470,2370,37360,11040,19840,6270,231060,11050,37370,2390,19860,37350,11060,32450,227480,41660,204340,32460,6250,231040,219890,212050,200510,32500,23700,204300,2400,37330,41600,46000,212070,37340,32510,72300,223630,219870,2420,200490,212090,208200,6210,111000,19900,6220,2430,37320,10460,37390,204240,223810,37380,41300,208520,230760,33580,223830,37400,24410,55000,230780,7060,212910,228200,24400,33570,2720,98600,55020,37420,10490,24420,2710,10480,223850,32000,98100,33550,2700,215060,102410,239410,223870,102400,33540,10470,2690,2810,107310,208580,204180,33660,32110,45100,2800,107300,33650,7110,230700,32120,116120,239450,215160,208600,102500,2790,208610,246210,2780,10430,10420,208620,204220,19990,33620,33610,2760,215120,19980,208630,37500,10400,33600,51060,204120,2610,32160,98200,234710,219540,2620,27800,6920,212780,33700,45300,51040,111300,204100,33710,208400,228320,2600,243360,20200,230860,51030,32130,33680,234740,32140,2590,33670,204140,228300,32150,51010,27810,51020,212740,2570,234650,228280,33780,208460,204060,10260,6980,219600,51000,2680,33790,24460,230820,212840,33760,10240,50980,24470,10250,215280,7000,33770,234630,228260,50990,24480,2640,219640,37600,50960,7010,33750,32200,50970,41400,98300,204080,208480,223910,107400,27900,7020,33730,50950,24500,98800,72000,2630,107410,212800,102600,208500,98810,33740,215350,58510,10700,2990,31800,102700,33320,50920,6810,219150,200190,24150,94000,6800,10690,203990,24140,50940,33340,3000,41050,58520,50930,200170,27920,24130,58540,41070,45400,107100,6840,41060,27940,24180,33280,6830,50910,212630,219190,227920,24170,200130,50900,6820,204030,58550,40970,58570,219200,3050,33390,31870,40960,58560,31860,55190,208860,6870,10630,10650,31850,6860,40990,55180,31840,6850,227900,37700,40980,41000,200080,24120,6910,111400,55230,3020,3010,212680,28000,224060,31830,50820,215390,33350,10660,6900,215360,55210,10680,227860,31820,31810,230410,58610,6880,41010,3030,212700,98400,208670,200060,224220,10560,203850,31920,102820,2850,230650,33440,200050,55130,31930,215470,55110,31910,33460,28050,50800,102840,10590,208640,2820,58400,31890,215450,200020,33420,234980,31900,212480,55140,107200,111600,200010,102810,212500,55150,37800,31880,41210,2840,208730,24210,10500,33510,219340,2920,228000,24220,10510,212580,45500,94200,41100,98500,215530,33520,2930,55040,33530,24200,10520,55050,98510,31980,234900,208710,10530,24240,227980,102850,203810,55100,239350,10540,215510,234940,2900,45450,33500,2910,203830,37990,211420,224300,104020,92230,7650,207080,42800,18450,7660,18460,230150,42810,221040,46600,216670,104000,49540,7670,3270,230170,38000,211400,92250,107800,38010,203680,221020,230190,7620,27220,11920,18480,16300,211440,207040,37960,18490,3320,18470,3300,37970,27200,37980,3310,207060,203650,203770,224360,37920,3220,42870,207020,37930,234100,31500,58300,3230,42850,7600,3200,49600,18500,224380,37940,211340,62100,220960,7610,37950,203750,241720,224320,203730,216610,206980,211380,46700,37900,92200,3260,207000,42820,46710,92210,37910,92220,211360,107900,224340,42830,34270,111800,42940,224420,46730,234160,3160,238050,38120,211280,7530,58230,42930,7520,46720,228760,16130,46750,3150,38140,238070,42920,31700,46740,38130,203560,224440,230310,42910,7500,49470,46760,58200,38090,38080,38110,31740,221120,18600,42890,7510,38100,92400,16180,3170,230330,27330,46770,16200,92300,43000,11900,38060,7470,38050,46790,230350,34190,42990,224500,203630,38070,27300,34180,42980,3130,46830,38030,42960,221080,49520,38020,211260,7450,46840,38040,34220,62000,7440,104100,234190,42950,220780,16020,92500,3520,211140,16030,18700,7420,207350,3530,12200,49300,3540,31300,216910,12210,211160,38240,16000,46850,12220,229890,234290,7400,99920,38230,42500,224540,211180,12160,207320,16060,220740,33900,3560,12170,49320,12180,33910,49330,38210,3570,99910,3580,12190,38220,16040,216930,228400,31250,237630,234350,99890,107600,12260,3460,38200,96300,22650,229970,16090,99900,3470,31260,104200,228440,38180,3483,3480,31240,7340,203510,38190,31280,216890,38160,22610,220680,224600,3490,12230,38170,27400,16120,207250,31290,99870,3500,237590,234310,12240,16100,38150,3510,31270,220700,22600,49400,12250,211120,237570,16110,224580,220900,15900,42670,47000,211010,3400,42660,224700,207230,18820,33990,22700,3420,42680,34010,34000,3410,207210,57970,7260,207190,34030,15930,234370,3430,115220,211050,15920,7250,217080,234390,217060,22670,115210,42650,207170,224640,230050,3450,115200,211070,15910,27600,3440,42640,15960,73230,33930,42730,57900,210950,3340,12140,115320,73220,3330,12130,224760,112100,7220,104320,7210,15950,33950,234490,7200,220860,12150,3350,15940,207150,3370,12110,42700,92600,3360,42690,31410,210990,12100,15990,31400,12120,15980,203350,220820,33980,3390,33970,15970,42710,3380,242110,96400,203160,97110,3830,26710,224780,23300,19000,23310,8140,11420,73210,38480,3810,73190,97100,57800,38490,15800,115100,207570,203140,34670,31100,3820,8160,11440,115110,34640,233530,73170,15750,3800,216130,34650,8170,11450,99700,207610,34630,115120,97120,216150,97130,233510,224820,8190,211900,216110,61600,38400,220440,23360,11480,207490,38410,38420,233550,23380,211880,8080,57730,203210,220420,23390,57740,38430,46200,34600,8100,19030,50130,207530,3730,203250,23400,38440,220460,38450,216090,11490,19020,23420,11500,38460,3720,92700,233570,50120,38600,31210,238530,8010,34810,46250,216290,57690,224900,3710,207430,34800,92900,57680,31200,11280,8000,3700,23450,31230,46270,73060,224920,23440,46260,31220,8040,31180,46220,220660,46210,19090,31170,211800,23460,61510,15620,224940,99810,61530,19080,8060,211780,61520,3650,216280,99830,46230,57700,31190,23500,224960,73020,229870,57620,73010,7940,23490,38530,207370,61500,207380,3630,224980,15740,11340,57610,46330,23510,3620,57600,11330,46320,216250,7980,11390,46280,23530,3610,92800,31110,211740,233720,26800,3600,57650,225000,7970,207400,50000,233700,15710,216210,11370,57640,31130,15700,7990,3590,207420,225020,11360,31120,46290,108500,238170,233740,15540,99410,38740,34410,7900,15520,46370,38720,42000,34420,7880,220240,99400,46380,72900,19200,46360,49800,72910,220260,23100,49810,7910,46340,27000,211670,15500,46350,216390,238110,7830,23120,46450,4000,46460,49900,216370,228960,23130,220160,26900,202970,229480,7810,207750,57500,19320,46440,46420,96800,202990,57510,7860,220200,3970,225140,7870,46430,3980,238130,3990,72850,207790,23140,46400,7840,108100,23150,38700,7850,211600,108110,15560,233840,34330,46410,7770,42120,46520,233860,61820,61810,7760,11520,216570,207710,49700,225180,108210,15400,3960,61800,108200,46510,42140,11550,238280,207690,225160,46500,211580,225200,207730,11560,7800,46490,229520,15390,97000,46480,3910,34500,38900,15380,15370,42170,42160,23200,3920,7780,27020,42190,38810,34470,11590,211500,96900,38800,3900,225220,229600,46570,42200,238210,11610,11604,61730,46560,42220,207670,7740,27050,34440,202860,46550,7730,242570,42210,27040,34460,46540,38830,57400,238240,207650,38820,225260,61700,229580,233980,42230,34450] 
    #[233570,50120,38600,31210,238530,8010,34810,46250,216290,57690,224900,3710,207430,34800,92900,57680,31200,11280,8000,3700,23450,31230,46270,73060,224920,23440,46260,31220,8040,31180,46220,220660,46210,19090,31170,211800,23460,61510,15620,224940,99810,61530,19080,8060,211780,61520,3650,216280,99830,46230,57700,31190,23500,224960,73020,229870,57620,73010,7940,23490,38530,207370,61500,207380,3630,224980,15740,11340,57610,46330,23510,3620,57600,11330,46320,216250,7980,11390,46280,23530,3610,92800,31110,211740,233720,26800,3600,57650,225000,7970,207400,50000,233700,15710,216210,11370,57640,31130,15700,7990,3590,207420,225020,11360,31120,46290,108500,238170,233740,15540,99410,38740,34410,7900,15520,46370,38720,42000,34420,7880,220240,99400,46380,72900,19200,46360,49800,72910,220260,23100,49810,7910,46340,27000,211670,15500,46350,216390,238110,7830,23120,46450,4000,46460,49900,216370,228960,23130,220160,26900,202970,229480,7810,207750,57500,19320,46440,46420,96800,202990,57510,7860,220200,3970,225140,7870,46430,3980,238130,3990,72850,207790,23140,46400,7840,108100,23150,38700,7850,211600,108110,15560,233840,34330,46410,7770,42120,46520,233860,61820,61810,7760,11520,216570,207710,49700,225180,108210,15400,3960,61800,108200,46510,42140,11550,238280,207690,225160,46500,211580,225200,207730,11560,7800,46490,229520,15390,97000,46480,3910,34500,38900,15380,15370,42170,42160,23200,3920,7780,27020,42190,38810,34470,11590,211500,96900,38800,3900,225220,229600,46570,42200,238210,11610,11604,61730,46560,42220,207670,7740,27050,34440,202860,46550,7730,242570,42210,27040,34460,46540,38830,57400,238240,207650,38820,225260,61700,229580,233980,42230,34450] 
  end
 
  def getColumnsFromRedis(ownedGames)
    beginTime = Time.now
    redis = Redis.new
    columns = redis.mget(ownedGames)
    endTime = Time.now
    @log.info { "Redis time: #{endTime-beginTime} seconds for #{columns.length} columns" } 
    columns  
  end 

  def getColumnsFromMySQL(ownedGames)
    beginTime = Time.now
    models = Model.all(:appid => ownedGames)
    endTime = Time.now
    @log.info { "MySQL time: #{endTime-beginTime} seconds for #{models.length} models" }
    models
  end
  
  def getColumnsFromMemcached(ownedGames)
    beginTime = Time.now
    cache = Memcached.new('localhost:11211', :no_block=>true, :buffer_requests=>true, :noreply=>true, :binary_protocol=>false)
    columns = cache.get(ownedGames)
    endTime = Time.now
    @log.info { "Memcached time: #{endTime-beginTime} seconds for #{columns.length} models" }
    columns
  end
end

recomms = Recomms.new
recomms.getScores(1, [])
