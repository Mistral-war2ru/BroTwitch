using System;
using System.IO;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using TwitchLib.Client;
using TwitchLib.Client.Models;
using TwitchLib.Communication.Clients;
using TwitchLib.Communication.Models;
using System.Diagnostics;

namespace BroTwitch
{
    public partial class Form1 : Form
    {
        Random rnd = new Random();
        private Bot b = new Bot();

        private bool streamer = false;

        private List<string> start_bro = new List<string>();
        private List<string> start_train = new List<string>();
        private List<string> start_craft = new List<string>();
        private List<string> start_event = new List<string>();
        private List<string> start_perk = new List<string>();
        private List<string> start_boss = new List<string>();
        private List<string> start_duel = new List<string>();
        private List<string> start_raid = new List<string>();
        private List<string> start_casino = new List<string>();

        private List<string> otvets_bro_ok = new List<string>();
        private List<string> otvets_train_ok = new List<string>();
        private List<string> otvets_craft_ok = new List<string>();
        private List<string> otvets_event_ok = new List<string>();
        private List<string> otvets_perk_ok = new List<string>();
        private List<string> otvets_boss_ok = new List<string>();
        private List<string> otvets_duel_ok = new List<string>();
        private List<string> otvets_raid_ok = new List<string>();
        private List<string> otvets_casino_ok = new List<string>();

        private List<string> otvets_bro_no = new List<string>();
        private List<string> otvets_train_no = new List<string>();
        private List<string> otvets_craft_no = new List<string>();
        private List<string> otvets_event_no = new List<string>();
        private List<string> otvets_perk_no = new List<string>();
        private List<string> otvets_boss_no = new List<string>();
        private List<string> otvets_duel_no = new List<string>();
        private List<string> otvets_raid_no = new List<string>();
        private List<string> otvets_casino_no = new List<string>();

        private List<string> trains = new List<string>();
        private List<string> crafts = new List<string>();
        private List<string> crafts_w = new List<string>();
        private List<string> crafts_a = new List<string>();
        private List<string> crafts_h = new List<string>();
        private List<string> crafts_s = new List<string>();
        private List<string> crafts_m = new List<string>();
        private List<string> perks = new List<string>();
        private List<string> bosses = new List<string>();
        private List<int> bosses_test = new List<int>();
        private List<string> duels = new List<string>();
        private List<string> raiders = new List<string>();
        private List<string> casinos = new List<string>();
        private int events = 0;
        private int days = 0;

        private bool raid = false;
        private DateTime raid_time;

        private string otvet_time = "@{0}, {1:F2} sec";
        private string otvet_days = "@{0}, The game has not reached the required stage. The ingame must have {1} days to complete this command!";

        private Dictionary<string, DateTime> bro_timings = new Dictionary<string, DateTime>();
        private Dictionary<string, DateTime> train_timings = new Dictionary<string, DateTime>();
        private Dictionary<string, DateTime> craft_timings = new Dictionary<string, DateTime>();
        private Dictionary<string, DateTime> event_timings = new Dictionary<string, DateTime>();
        private Dictionary<string, DateTime> perk_timings = new Dictionary<string, DateTime>();
        private Dictionary<string, DateTime> boss_timings = new Dictionary<string, DateTime>();
        private Dictionary<string, DateTime> duel_timings = new Dictionary<string, DateTime>();
        private Dictionary<string, DateTime> raid_timings = new Dictionary<string, DateTime>();
        private Dictionary<string, DateTime> casino_timings = new Dictionary<string, DateTime>();
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if ((textBox1.Text.Length >= 8) && (textBox2.Text.Length >= 3))
            {
                streamer = false;
                label3.Text = "Connecting to twitch...";
                if (b.client.IsConnected)b.client.Disconnect();
                ConnectionCredentials credentials = new ConnectionCredentials("BroTwitch", textBox1.Text);
                var clientOptions = new ClientOptions
                {
                    MessagesAllowedInPeriod = 750,
                    ThrottlingPeriod = TimeSpan.FromSeconds(30)
                };
                WebSocketClient customClient = new WebSocketClient(clientOptions);
                b.client = new TwitchClient(customClient);
                b.con = 0;

                b.client.Initialize(credentials, textBox2.Text);

                b.client.OnMessageReceived += b.Client_OnMessageReceived;
                b.client.OnJoinedChannel += b.Client_OnJoinedChannel;


                b.client.Connect();
                if (b.client.IsConnected)
                {
                    b.con = 2;
                }
            }
            else
                label3.Text = "Twitch Error! Write correct data first!";
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            if (b.con == 0) label3.Text = "Twitch NOT connected";
            if (b.con == 1)
            {
                label3.Text = "Twitch connected";
                if (!streamer)
                {
                    streamer = true;
                    DirectoryInfo dr = new DirectoryInfo(label4.Text);
                    foreach (FileInfo fl in dr.GetFiles("!streamer*")) fl.Delete();
                    FileInfo f = new FileInfo(label4.Text + "/!streamer " + textBox2.Text);
                    if (!f.Exists)
                    {
                        f.CreateText().Close();
                    }
                }
            }
            if (b.con == 2) label3.Text = "Connecting to twitch...";
            if (b.text == "")
            {
                if (b.msgs.Count != 0)
                {
                    b.text = b.msgs[0];
                    b.msgs.RemoveAt(0);
                }
            }
            if (b.text != "")
            {
                string[] splt = b.text.Split('\x03');
                string user = splt[0];
                string msgg = splt[1];
                string otvet = "";
                if (msgg == "!brother")
                {
                    int day = 0;
                    try { day = Convert.ToInt32(textBox20.Text); }
                    catch (Exception) { textBox20.Text = "0"; }
                    if (days >= day)
                    {
                        double tm = 60;
                        try
                        {
                            tm = Convert.ToDouble(textBox8.Text);
                        }
                        catch (Exception) { textBox8.Text = "60"; }
                        DateTime n = DateTime.Now;
                        double dif = tm + 1;
                        if (bro_timings.Keys.Contains(user)) dif = (n - bro_timings[user]).TotalSeconds;
                        else bro_timings.Add(user, n);
                        if (dif >= tm)
                        {
                            bro_timings[user] = n;
                            int chance = 50;
                            try { chance = Convert.ToInt32(textBox3.Text); }
                            catch (Exception) { textBox3.Text = "50"; }
                            if ((chance < 0) || (chance > 100)) textBox3.Text = "50";
                            bool result = rnd.Next(0, 100) < chance;
                            if (result)
                            {
                                if (label4.Text != "")
                                {
                                    try
                                    {
                                        FileInfo f = new FileInfo(label4.Text + "/!bro " + user);
                                        if (!f.Exists)
                                        {
                                            f.CreateText().Close();
                                        }
                                    }
                                    catch (Exception) { }
                                }
                            }
                            otvet = string.Format(start_bro[rnd.Next(0, start_bro.Count)], user)
                                + (result ?
                                otvets_bro_ok[rnd.Next(0, otvets_bro_ok.Count)] :
                                otvets_bro_no[rnd.Next(0, otvets_bro_no.Count)]
                                ).ToString();
                        }
                        else otvet = string.Format(otvet_time, user, tm - dif);
                    }
                    else otvet = string.Format(otvet_days, user, day);
                }
                else if (msgg == "!training")
                {
                    int day = 5;
                    try { day = Convert.ToInt32(textBox21.Text); }
                    catch (Exception) { textBox21.Text = "5"; }
                    if (days >= day)
                    {
                        double tm = 90;
                        try
                        {
                            tm = Convert.ToDouble(textBox7.Text);
                        }
                        catch (Exception) { textBox7.Text = "90"; }
                        DateTime n = DateTime.Now;
                        double dif = tm + 1;
                        if (train_timings.Keys.Contains(user)) dif = (n - train_timings[user]).TotalSeconds;
                        else train_timings.Add(user, n);
                        if (dif >= tm)
                        {
                            train_timings[user] = n;
                            int chance = 25;
                            try { chance = Convert.ToInt32(textBox4.Text); }
                            catch (Exception) { textBox4.Text = "25"; }
                            if ((chance < 0) || (chance > 100)) textBox4.Text = "25";
                            bool result = rnd.Next(0, 100) < chance;
                            if (result) trains.Add(user);
                            otvet = string.Format(start_train[rnd.Next(0, start_train.Count)], user)
                                + (result ?
                                otvets_train_ok[rnd.Next(0, otvets_train_ok.Count)] :
                                otvets_train_no[rnd.Next(0, otvets_train_no.Count)]
                                ).ToString();
                        }
                        else otvet = string.Format(otvet_time, user, tm - dif);
                    }
                    else otvet = string.Format(otvet_days, user, day);
                }
                else if (msgg.Contains("!craft"))
                {
                    int day = 15;
                    try { day = Convert.ToInt32(textBox23.Text); }
                    catch (Exception) { textBox23.Text = "15"; }
                    if (days >= day)
                    {
                        double tm = 3600;
                        try
                        {
                            tm = Convert.ToDouble(textBox9.Text);
                        }
                        catch (Exception) { textBox9.Text = "3600"; }
                        DateTime n = DateTime.Now;
                        double dif = tm + 1;
                        if (craft_timings.Keys.Contains(user)) dif = (n - craft_timings[user]).TotalSeconds;
                        else craft_timings.Add(user, n);
                        if (dif >= tm)
                        {
                            craft_timings[user] = n;
                            int chance = 10;
                            try { chance = Convert.ToInt32(textBox10.Text); }
                            catch (Exception) { textBox10.Text = "10"; }
                            if ((chance < 0) || (chance > 100)) textBox10.Text = "10";
                            if ((msgg == "!craft_meme") && (user == "ed_gorod")) chance = 101;
                            bool result = rnd.Next(0, 100) < chance;
                            if (result)
                            {
                                if (msgg == "!craft_weapon") crafts_w.Add(user);
                                else if (msgg == "!craft_armor") crafts_a.Add(user);
                                else if (msgg == "!craft_helmet") crafts_h.Add(user);
                                else if (msgg == "!craft_shield") crafts_s.Add(user);
                                else if (msgg == "!craft_meme") crafts_m.Add(user);
                                else crafts.Add(user);
                            }
                            otvet = string.Format(start_craft[rnd.Next(0, start_craft.Count)], user)
                                + (result ?
                                otvets_craft_ok[rnd.Next(0, otvets_craft_ok.Count)] :
                                otvets_craft_no[rnd.Next(0, otvets_craft_no.Count)]
                                ).ToString();
                        }
                        else otvet = string.Format(otvet_time, user, tm - dif);
                    }
                    else otvet = string.Format(otvet_days, user, day);
                }
                else if (msgg == "!perk")
                {
                    int day = 5;
                    try { day = Convert.ToInt32(textBox24.Text); }
                    catch (Exception) { textBox24.Text = "5"; }
                    if (days >= day)
                    {
                        double tm = 600;
                        try
                        {
                            tm = Convert.ToDouble(textBox11.Text);
                        }
                        catch (Exception) { textBox11.Text = "600"; }
                        DateTime n = DateTime.Now;
                        double dif = tm + 1;
                        if (perk_timings.Keys.Contains(user)) dif = (n - perk_timings[user]).TotalSeconds;
                        else perk_timings.Add(user, n);
                        if (dif >= tm)
                        {
                            perk_timings[user] = n;
                            int chance = 20;
                            try { chance = Convert.ToInt32(textBox12.Text); }
                            catch (Exception) { textBox12.Text = "20"; }
                            if ((chance < 0) || (chance > 100)) textBox12.Text = "20";
                            bool result = rnd.Next(0, 100) < chance;
                            if (result) perks.Add(user);
                            otvet = string.Format(start_perk[rnd.Next(0, start_perk.Count)], user)
                                + (result ?
                                otvets_perk_ok[rnd.Next(0, otvets_perk_ok.Count)] :
                                otvets_perk_no[rnd.Next(0, otvets_perk_no.Count)]
                                ).ToString();
                        }
                        else otvet = string.Format(otvet_time, user, tm - dif);
                    }
                    else otvet = string.Format(otvet_days, user, day);
                }
                else if ((msgg == "!boss") || msgg.Contains("!boss_test"))
                {
                    int day = 40;
                    try { day = Convert.ToInt32(textBox25.Text); }
                    catch (Exception) { textBox25.Text = "40"; }
                    if (days >= day)
                    {
                        double tm = 400;
                        try
                        {
                            tm = Convert.ToDouble(textBox13.Text);
                        }
                        catch (Exception) { textBox13.Text = "400"; }
                        DateTime n = DateTime.Now;
                        if (msgg.Contains("!boss_test") && (user == "ed_gorod")) tm = 0;
                        double dif = tm + 1;
                        if (boss_timings.Keys.Contains(user)) dif = (n - boss_timings[user]).TotalSeconds;
                        else boss_timings.Add(user, n);
                        if (dif >= tm)
                        {
                            boss_timings[user] = n;
                            int chance = 10;
                            try { chance = Convert.ToInt32(textBox14.Text); }
                            catch (Exception) { textBox12.Text = "10"; }
                            if ((chance < 0) || (chance > 100)) textBox14.Text = "10";
                            if (msgg.Contains("!boss_test") && (user == "ed_gorod")) chance = 101;
                            bool result = rnd.Next(0, 100) < chance;
                            if (result)
                            {
                                if (msgg.Contains("!boss_test") && (user == "ed_gorod"))
                                {
                                    string bossk = new string(msgg.Where(char.IsDigit).ToArray());
                                    try { bosses_test.Add(Convert.ToInt32(bossk)); }
                                    catch (Exception) { bosses_test.Add(0); }
                                }
                                else bosses.Add(user);
                            }
                            otvet = string.Format(start_boss[rnd.Next(0, start_boss.Count)], user)
                                + (result ?
                                otvets_boss_ok[rnd.Next(0, otvets_boss_ok.Count)] :
                                otvets_boss_no[rnd.Next(0, otvets_boss_no.Count)]
                                ).ToString();
                        }
                        else otvet = string.Format(otvet_time, user, tm - dif);
                    }
                    else otvet = string.Format(otvet_days, user, day);
                }
                else if (msgg == "!duel")
                {
                    int day = 50;
                    try { day = Convert.ToInt32(textBox26.Text); }
                    catch (Exception) { textBox26.Text = "50"; }
                    if (days >= day)
                    {
                        double tm = 1800;
                        try
                        {
                            tm = Convert.ToDouble(textBox15.Text);
                        }
                        catch (Exception) { textBox15.Text = "1800"; }
                        DateTime n = DateTime.Now;
                        double dif = tm + 1;
                        if (duel_timings.Keys.Contains(user)) dif = (n - duel_timings[user]).TotalSeconds;
                        else duel_timings.Add(user, n);
                        if (dif >= tm)
                        {
                            duel_timings[user] = n;
                            int chance = 70;
                            try { chance = Convert.ToInt32(textBox16.Text); }
                            catch (Exception) { textBox16.Text = "70"; }
                            if ((chance < 0) || (chance > 100)) textBox16.Text = "70";
                            bool result = rnd.Next(0, 100) < chance;
                            if (result) duels.Add(user);
                            otvet = string.Format(start_duel[rnd.Next(0, start_duel.Count)], user)
                                + (result ?
                                otvets_duel_ok[rnd.Next(0, otvets_duel_ok.Count)] :
                                otvets_duel_no[rnd.Next(0, otvets_duel_no.Count)]
                                ).ToString();
                        }
                        else otvet = string.Format(otvet_time, user, tm - dif);
                    }
                    else otvet = string.Format(otvet_days, user, day);
                }
                else if (msgg == "!raid")
                {
                    int day = 30;
                    try { day = Convert.ToInt32(textBox28.Text); }
                    catch (Exception) { textBox28.Text = "30"; }
                    if (days >= day)
                    {
                        if (!raid)
                        {
                            double tm = 2500;
                            try
                            {
                                tm = Convert.ToDouble(textBox29.Text);
                            }
                            catch (Exception) { textBox29.Text = "2500"; }
                            DateTime n = DateTime.Now;
                            double dif = tm + 1;
                            if (raid_timings.Keys.Contains(user)) dif = (n - raid_timings[user]).TotalSeconds;
                            else raid_timings.Add(user, n);
                            if (dif >= tm)
                            {
                                raid_timings[user] = n;
                                int chance = 20;
                                try { chance = Convert.ToInt32(textBox30.Text); }
                                catch (Exception) { textBox30.Text = "20"; }
                                if ((chance < 0) || (chance > 100)) textBox30.Text = "20";
                                bool result = rnd.Next(0, 100) < chance;
                                if (result)
                                {
                                    raiders.Add(user);
                                    raid_time = DateTime.Now;
                                    raid = true;
                                }
                                double rtm = 60;
                                try
                                {
                                    rtm = Convert.ToDouble(textBox31.Text);
                                }
                                catch (Exception) { textBox31.Text = "60"; }
                                otvet = string.Format(start_raid[rnd.Next(0, start_raid.Count)], user)
                                    + (result ?
                                    otvets_raid_ok[rnd.Next(0, otvets_raid_ok.Count)]
                                    + string.Format("\nStarting raid! Only {0:F2} sec left!", rtm) :
                                    otvets_raid_no[rnd.Next(0, otvets_raid_no.Count)]
                                    ).ToString();
                            }
                            else otvet = string.Format(otvet_time, user, tm - dif);
                        }
                        else
                        {
                            double rtm = 60;
                            try
                            {
                                rtm = Convert.ToDouble(textBox31.Text);
                            }
                            catch (Exception) { textBox31.Text = "60"; }
                            double dif = (DateTime.Now - raid_time).TotalSeconds;
                            raiders.Add(user);
                            otvet = string.Format(start_raid[rnd.Next(0, start_raid.Count)], user)
                                    + otvets_raid_ok[rnd.Next(0, otvets_raid_ok.Count)].ToString()
                                    + string.Format("\nStarting raid! Only {0:F2} sec left!", rtm - dif);
                        }
                    }
                    else otvet = string.Format(otvet_days, user, day);
                }
                else if (msgg == "!casino")
                {
                    int day = 2;
                    try { day = Convert.ToInt32(textBox32.Text); }
                    catch (Exception) { textBox32.Text = "2"; }
                    if (days >= day)
                    {
                        double tm = 1600;
                        try
                        {
                            tm = Convert.ToDouble(textBox33.Text);
                        }
                        catch (Exception) { textBox33.Text = "1600"; }
                        DateTime n = DateTime.Now;
                        double dif = tm + 1;
                        if (casino_timings.Keys.Contains(user)) dif = (n - casino_timings[user]).TotalSeconds;
                        else casino_timings.Add(user, n);
                        if (dif >= tm)
                        {
                            casino_timings[user] = n;
                            int chance = 20;
                            try { chance = Convert.ToInt32(textBox34.Text); }
                            catch (Exception) { textBox34.Text = "20"; }
                            if ((chance < 0) || (chance > 100)) textBox34.Text = "20";
                            bool result = rnd.Next(0, 100) < chance;
                            if (result) casinos.Add(user);
                            otvet = string.Format(start_casino[rnd.Next(0, start_casino.Count)], user)
                                + (result ?
                                otvets_casino_ok[rnd.Next(0, otvets_casino_ok.Count)] :
                                otvets_casino_no[rnd.Next(0, otvets_casino_no.Count)]
                                ).ToString();
                        }
                        else otvet = string.Format(otvet_time, user, tm - dif);
                    }
                    else otvet = string.Format(otvet_days, user, day);
                }
                else if (msgg == "!event")
                {
                    int day = 10;
                    try { day = Convert.ToInt32(textBox22.Text); }
                    catch (Exception) { textBox22.Text = "10"; }
                    if (days >= day)
                    {
                        double tm = 120;
                        try
                        {
                            tm = Convert.ToDouble(textBox6.Text);
                        }
                        catch (Exception) { textBox6.Text = "120"; }
                        DateTime n = DateTime.Now;
                        double dif = tm + 1;
                        if (event_timings.Keys.Contains(user)) dif = (n - event_timings[user]).TotalSeconds;
                        else event_timings.Add(user, n);
                        if (dif >= tm)
                        {
                            event_timings[user] = n;
                            int chance = 43;
                            try { chance = Convert.ToInt32(textBox5.Text); }
                            catch (Exception) { textBox5.Text = "43"; }
                            if ((chance < 0) || (chance > 100)) textBox5.Text = "43";
                            bool result = rnd.Next(0, 100) < chance;
                            if (result) events++;
                            otvet = string.Format(start_event[rnd.Next(0, start_event.Count)], user)
                                + (result ?
                                otvets_event_ok[rnd.Next(0, otvets_event_ok.Count)] :
                                otvets_event_no[rnd.Next(0, otvets_event_no.Count)]
                                ).ToString();
                        }
                        else otvet = string.Format(otvet_time, user, tm - dif);
                    }
                    else otvet = string.Format(otvet_days, user, day);
                }
                else if (msgg == "!day")
                {
                    otvet = "Current InGame Day: " + days.ToString();
                }
                if (otvet != "")
                {
                    if (b.client.IsConnected)
                    {
                        if (b.client.JoinedChannels.Count != 0)
                        {
                            b.client.SendMessage(b.chan, otvet);
                        }
                    }
                }
                b.text = "";
            }
            if (label4.Text != "")
            {
                if (trains.Count != 0)
                {
                    try
                    {
                        FileInfo f = new FileInfo(label4.Text + "/!train " + trains[0]);
                        if (!f.Exists)
                        {
                            f.CreateText().Close();
                            trains.RemoveAt(0);
                        }
                    }
                    catch (Exception) { }
                }
                if (crafts_w.Count != 0)
                {
                    try
                    {
                        FileInfo f = new FileInfo(label4.Text + "/!craftw " + crafts_w[0]);
                        if (!f.Exists)
                        {
                            f.CreateText().Close();
                            crafts_w.RemoveAt(0);
                        }
                    }
                    catch (Exception) { }
                }
                if (crafts_a.Count != 0)
                {
                    try
                    {
                        FileInfo f = new FileInfo(label4.Text + "/!crafta " + crafts_a[0]);
                        if (!f.Exists)
                        {
                            f.CreateText().Close();
                            crafts_a.RemoveAt(0);
                        }
                    }
                    catch (Exception) { }
                }
                if (crafts_h.Count != 0)
                {
                    try
                    {
                        FileInfo f = new FileInfo(label4.Text + "/!crafth " + crafts_h[0]);
                        if (!f.Exists)
                        {
                            f.CreateText().Close();
                            crafts_h.RemoveAt(0);
                        }
                    }
                    catch (Exception) { }
                }
                if (crafts_s.Count != 0)
                {
                    try
                    {
                        FileInfo f = new FileInfo(label4.Text + "/!crafts " + crafts_s[0]);
                        if (!f.Exists)
                        {
                            f.CreateText().Close();
                            crafts_s.RemoveAt(0);
                        }
                    }
                    catch (Exception) { }
                }
                if (crafts.Count != 0)
                {
                    try
                    {
                        FileInfo f = new FileInfo(label4.Text + "/!craft " + crafts[0]);
                        if (!f.Exists)
                        {
                            f.CreateText().Close();
                            crafts.RemoveAt(0);
                        }
                    }
                    catch (Exception) { }
                }
                if (crafts_m.Count != 0)
                {
                    try
                    {
                        FileInfo f = new FileInfo(label4.Text + "/!craftm " + crafts_m[0]);
                        if (!f.Exists)
                        {
                            f.CreateText().Close();
                            crafts_m.RemoveAt(0);
                        }
                    }
                    catch (Exception) { }
                }
                if (perks.Count != 0)
                {
                    try
                    {
                        FileInfo f = new FileInfo(label4.Text + "/!perk " + perks[0]);
                        if (!f.Exists)
                        {
                            f.CreateText().Close();
                            perks.RemoveAt(0);
                        }
                    }
                    catch (Exception) { }
                }
                if (bosses.Count != 0)
                {
                    try
                    {
                        FileInfo f = new FileInfo(label4.Text + "/!boss " + bosses[0]);
                        if (!f.Exists)
                        {
                            f.CreateText().Close();
                            bosses.RemoveAt(0);
                        }
                    }
                    catch (Exception) { }
                }
                if (bosses_test.Count != 0)
                {
                    try
                    {
                        FileInfo f = new FileInfo(label4.Text + "/!boss" + bosses_test[0].ToString() + " ed_gorod");
                        if (!f.Exists)
                        {
                            f.CreateText().Close();
                            bosses_test.RemoveAt(0);
                        }
                    }
                    catch (Exception) { }
                }
                if (duels.Count != 0)
                {
                    try
                    {
                        DirectoryInfo dr = new DirectoryInfo(label4.Text);
                        FileInfo f1 = new FileInfo(label4.Text + "/!duel1 " + duels[0]);
                        if (f1.Exists)
                        {
                            string d = duels[0];
                            duels.RemoveAt(0);
                            if (duels.Count() != 0)
                            {
                                duels.Reverse();
                                duels.Add(d);
                                duels.Reverse();
                            }
                        }
                        else
                        {
                            if (dr.GetFiles("!duel1*").Count() == 0)
                            {
                                f1.CreateText().Close();
                                duels.RemoveAt(0);
                            }
                            else
                            {
                                FileInfo f = new FileInfo(label4.Text + "/!duel2 " + duels[0]);
                                if (!f.Exists)
                                {
                                    f.CreateText().Close();
                                    duels.RemoveAt(0);
                                }
                            }
                        }
                    }
                    catch (Exception) { }
                }
                if (raiders.Count > 0)
                {
                    if (raid)
                    {
                        double rtm = 60;
                        try
                        {
                            rtm = Convert.ToDouble(textBox31.Text);
                        }
                        catch (Exception) { textBox31.Text = "60"; }
                        double dif = (DateTime.Now - raid_time).TotalSeconds;
                        if ((rtm - dif) < 1)
                        {
                            raid = false;
                            try
                            {
                                FileInfo f = new FileInfo(label4.Text + "/!craid");
                                if (!f.Exists)f.CreateText().Close();
                            }
                            catch (Exception) { }
                            while (raiders.Count > 0)
                            {
                                try
                                {
                                    FileInfo f = new FileInfo(label4.Text + "/!raid " + raiders[0]);
                                    if (!f.Exists)f.CreateText().Close();
                                }
                                catch (Exception) { }
                                raiders.RemoveAt(0);
                            }
                            try
                            {
                                FileInfo f = new FileInfo(label4.Text + "/!sraid");
                                if (!f.Exists) f.CreateText().Close();
                            }
                            catch (Exception) { }
                            if (b.client.IsConnected)
                            {
                                if (b.client.JoinedChannels.Count != 0)
                                {
                                    b.client.SendMessage(b.chan, "Raid Started!");
                                }
                            }
                        }
                    }
                }
                if (casinos.Count != 0)
                {
                    try
                    {
                        FileInfo f = new FileInfo(label4.Text + "/!pot " + casinos[0]);
                        if (!f.Exists)
                        {
                            f.CreateText().Close();
                            casinos.RemoveAt(0);
                        }
                    }
                    catch (Exception) { }
                }
                if (events > 0)
                {
                    try
                    {
                        FileInfo f = new FileInfo(label4.Text + "/!event");
                        if (!f.Exists)
                        {
                            f.CreateText().Close();
                            events--;
                        }
                    }
                    catch (Exception) { }
                }

                DirectoryInfo dir = new DirectoryInfo(label4.Text);
                foreach (FileInfo f in dir.EnumerateFiles("!day *", SearchOption.TopDirectoryOnly))
                {
                    string fname = f.Name;
                    try{ f.Delete(); }
                    catch (Exception) { }
                    try{ days = Convert.ToInt32(fname.Replace("!day ", "")); }
                    catch (Exception) { }
                }
                label19.Text = "InGame day: " + days.ToString();
            }
        }

        private void load_text(string file, ref List<string> l, string empty)
        {
            if (File.Exists(file))
            {
                StreamReader F = File.OpenText(file);
                while (!F.EndOfStream)
                {
                    l.Add(F.ReadLine());
                }
                F.Close();
            }
            if (l.Count == 0) l.Add(empty);
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            label4.Text = "";
            if (File.Exists("record.save"))
            {
                StreamReader F = File.OpenText("record.save");
                while (!F.EndOfStream)
                {
                    string S = F.ReadLine();
                    textBox1.Text = S;
                    S = F.ReadLine();
                    textBox2.Text = S;
                    S = F.ReadLine();
                    label4.Text = S;
                    S = F.ReadLine();
                    if (S != null) textBox3.Text = S;
                    S = F.ReadLine();
                    if (S != null) textBox4.Text = S;
                    S = F.ReadLine();
                    if (S != null) textBox5.Text = S;
                    S = F.ReadLine();
                    if (S != null) textBox6.Text = S;
                    S = F.ReadLine();
                    if (S != null) textBox7.Text = S;
                    S = F.ReadLine();
                    if (S != null) textBox8.Text = S;
                    S = F.ReadLine();
                    if (S != null) textBox9.Text = S;
                    S = F.ReadLine();
                    if (S != null) textBox10.Text = S;
                    S = F.ReadLine();
                    if (S != null) textBox11.Text = S;
                    S = F.ReadLine();
                    if (S != null) textBox12.Text = S;
                    S = F.ReadLine();
                    if (S != null) textBox13.Text = S;
                    S = F.ReadLine();
                    if (S != null) textBox14.Text = S;
                    S = F.ReadLine();
                    if (S != null) textBox15.Text = S;
                    S = F.ReadLine();
                    if (S != null) textBox16.Text = S;
                    S = F.ReadLine();
                    if (S != null) textBox20.Text = S;
                    S = F.ReadLine();
                    if (S != null) textBox21.Text = S;
                    S = F.ReadLine();
                    if (S != null) textBox22.Text = S;
                    S = F.ReadLine();
                    if (S != null) textBox23.Text = S;
                    S = F.ReadLine();
                    if (S != null) textBox24.Text = S;
                    S = F.ReadLine();
                    if (S != null) textBox25.Text = S;
                    S = F.ReadLine();
                    if (S != null) textBox26.Text = S;
                    S = F.ReadLine();
                    if (S != null) try { days = Convert.ToInt32(S); }catch (Exception) { }
                    S = F.ReadLine();
                    if (S != null) textBox28.Text = S;
                    S = F.ReadLine();
                    if (S != null) textBox29.Text = S;
                    S = F.ReadLine();
                    if (S != null) textBox30.Text = S;
                    S = F.ReadLine();
                    if (S != null) textBox31.Text = S;
                    S = F.ReadLine();
                    if (S != null) textBox32.Text = S;
                    S = F.ReadLine();
                    if (S != null) textBox33.Text = S;
                    S = F.ReadLine();
                    if (S != null) textBox34.Text = S;
                }
                F.Close();
            }

            load_text("text\\otvets_bro_ok.txt", ref otvets_bro_ok, "");
            load_text("text\\otvets_bro_no.txt", ref otvets_bro_no, "");
            load_text("text\\otvets_train_ok.txt", ref otvets_train_ok, "");
            load_text("text\\otvets_train_no.txt", ref otvets_train_no, "");
            load_text("text\\otvets_craft_ok.txt", ref otvets_craft_ok, "");
            load_text("text\\otvets_craft_no.txt", ref otvets_craft_no, "");
            load_text("text\\otvets_perk_ok.txt", ref otvets_perk_ok, "");
            load_text("text\\otvets_perk_no.txt", ref otvets_perk_no, "");
            load_text("text\\otvets_event_ok.txt", ref otvets_event_ok, "");
            load_text("text\\otvets_event_no.txt", ref otvets_event_no, "");
            load_text("text\\otvets_boss_ok.txt", ref otvets_boss_ok, "");
            load_text("text\\otvets_boss_no.txt", ref otvets_boss_no, "");
            load_text("text\\otvets_duel_ok.txt", ref otvets_duel_ok, "");
            load_text("text\\otvets_duel_no.txt", ref otvets_duel_no, "");
            load_text("text\\otvets_raid_ok.txt", ref otvets_raid_ok, "");
            load_text("text\\otvets_raid_no.txt", ref otvets_raid_no, "");
            load_text("text\\otvets_casino_ok.txt", ref otvets_casino_ok, "");
            load_text("text\\otvets_casino_no.txt", ref otvets_casino_no, "");
            load_text("text\\start_bro.txt", ref start_bro, "{0}");
            load_text("text\\start_train.txt", ref start_train, "{0}");
            load_text("text\\start_craft.txt", ref start_craft, "{0}");
            load_text("text\\start_perk.txt", ref start_perk, "{0}");
            load_text("text\\start_event.txt", ref start_event, "{0}");
            load_text("text\\start_boss.txt", ref start_boss, "{0}");
            load_text("text\\start_duel.txt", ref start_duel, "{0}");
            load_text("text\\start_raid.txt", ref start_raid, "{0}");
            load_text("text\\start_casino.txt", ref start_casino, "{0}");

            if (File.Exists("text\\otvet_time.txt"))
            {
                StreamReader F = File.OpenText("text\\otvet_time.txt");
                otvet_time = F.ReadLine();
                F.Close();
            }
        }

        private void write_bytes(FileStream F,string text)
        {
            byte[] info = new UTF8Encoding(true).GetBytes(text);
            F.Write(info, 0, info.Length);
        }

        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (File.Exists("record.save"))
                File.Delete("record.save");
            FileStream F = File.OpenWrite("record.save");
            write_bytes(F, textBox1.Text + "\n");
            write_bytes(F, textBox2.Text + "\n");
            write_bytes(F, label4.Text + "\n");
            write_bytes(F, textBox3.Text + "\n");
            write_bytes(F, textBox4.Text + "\n");
            write_bytes(F, textBox5.Text + "\n");
            write_bytes(F, textBox6.Text + "\n");
            write_bytes(F, textBox7.Text + "\n");
            write_bytes(F, textBox8.Text + "\n");
            write_bytes(F, textBox9.Text + "\n");
            write_bytes(F, textBox10.Text + "\n");
            write_bytes(F, textBox11.Text + "\n");
            write_bytes(F, textBox12.Text + "\n");
            write_bytes(F, textBox13.Text + "\n");
            write_bytes(F, textBox14.Text + "\n");
            write_bytes(F, textBox15.Text + "\n");
            write_bytes(F, textBox16.Text + "\n");
            write_bytes(F, textBox20.Text + "\n");
            write_bytes(F, textBox21.Text + "\n");
            write_bytes(F, textBox22.Text + "\n");
            write_bytes(F, textBox23.Text + "\n");
            write_bytes(F, textBox24.Text + "\n");
            write_bytes(F, textBox25.Text + "\n");
            write_bytes(F, textBox26.Text + "\n");
            write_bytes(F, days.ToString() + "\n");
            write_bytes(F, textBox28.Text + "\n");
            write_bytes(F, textBox29.Text + "\n");
            write_bytes(F, textBox30.Text + "\n");
            write_bytes(F, textBox31.Text + "\n");
            write_bytes(F, textBox32.Text + "\n");
            write_bytes(F, textBox33.Text + "\n");
            write_bytes(F, textBox34.Text + "\n");
            F.Close();
        }

        private void linkLabel1_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            linkLabel1.LinkVisited = true;
            System.Diagnostics.Process.Start("https://github.com/Mistral-war2ru");
        }

        private void button2_Click(object sender, EventArgs e)
        {
            if(folderBrowserDialog1.ShowDialog()==DialogResult.OK)
            {
                label4.Text = folderBrowserDialog1.SelectedPath;
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            if ((label4.Text != "") && (textBox17.Text != "") && (textBox18.Text != ""))
            {
                try
                {
                    DirectoryInfo dr = new DirectoryInfo(label4.Text);
                    foreach (FileInfo fl in dr.GetFiles("!duel*")) fl.Delete();
                    FileInfo f = new FileInfo(label4.Text + "/!duel1 " + textBox17.Text);
                    if (!f.Exists)
                    {
                        f.CreateText().Close();
                    }
                    FileInfo f2 = new FileInfo(label4.Text + "/!duel2 " + textBox18.Text);
                    if (!f2.Exists)
                    {
                        f2.CreateText().Close();
                    }
                }
                catch (Exception) { }
            }
        }

        private void button4_Click(object sender, EventArgs e)
        {
            if (label4.Text != "")
            {
                try
                {
                    FileInfo f = new FileInfo(label4.Text + "/!diff");
                    if (!f.Exists)
                    {
                        f.CreateText().Close();
                    }
                }
                catch (Exception) { }
            }
        }

        private void button5_Click(object sender, EventArgs e)
        {
            if (label4.Text != "")
            {
                try
                {
                    string bossk = new string(textBox19.Text.Where(char.IsDigit).ToArray());
                    FileInfo f = new FileInfo(label4.Text + "/!boss" + bossk + " " + textBox2.Text);
                    if (!f.Exists)
                    {
                        f.CreateText().Close();
                    }
                }
                catch (Exception) { }
            }
        }

        private void spawn_secret_boss(int b)
        {
            if (label4.Text != "")
            {
                try
                {
                    FileInfo f = new FileInfo(label4.Text + "/!sboss" + b.ToString());
                    if (!f.Exists)
                    {
                        f.CreateText().Close();
                    }
                }
                catch (Exception) { }
            }
        }

        private void linkLabel2_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            spawn_secret_boss(0);
        }

        private void linkLabel3_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            spawn_secret_boss(1);
        }

        private void linkLabel4_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            spawn_secret_boss(2);
        }

        private void linkLabel5_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            spawn_secret_boss(3);
        }

        private void linkLabel6_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            spawn_secret_boss(6);
        }

        private void linkLabel7_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            spawn_secret_boss(4);
        }

        private void linkLabel8_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            spawn_secret_boss(5);
        }

        private void linkLabel9_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            spawn_secret_boss(7);
        }

        private void linkLabel10_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            spawn_secret_boss(8);
        }

        private void button6_Click(object sender, EventArgs e)
        {
            if (label4.Text != "")
            {
                try
                {
                    FileInfo f = new FileInfo(label4.Text + "/!schange " + textBox27.Text);
                    if (!f.Exists)
                    {
                        f.CreateText().Close();
                    }
                }
                catch (Exception) { }
            }
        }

        private void linkLabel11_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            linkLabel11.LinkVisited = true;
            System.Diagnostics.Process.Start("https://twitchapps.com/tmi/");
        }

        private void linkLabel12_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            linkLabel12.LinkVisited = true;
            MessageBox.Show("Find the GAME folder,\n probably it will be named Battle Brothers\nfind data folder there,\nfind twitch folder in here\n if cannot find then create it\n press button and select this twitch folder\n in the end you must get something like that:\n C:\\Battle Brothers\\data\\twitch\n or maybe for example\n C:\\Steam\\steamapps\\common\\Battle Brothers\\data\\twitch");
        }

        private void linkLabel13_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            linkLabel13.LinkVisited = true;
            MessageBox.Show("Almost every command have % chance to success or not,\n also have timer (in seconds)\n how often viewer can try call this command\n (each viewer have personal timer for each command)\n also some commands can only be called\n if game reached needed day in campaign\n Raid command also have additional timer\n on to how long raid preparation is going\n all of those parameters can be changed as you need\n chance % can be from 0 to 100");
        }

        private void linkLabel14_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            linkLabel14.LinkVisited = true;
            MessageBox.Show("How viewer use it: write in chat !brother\n if success new random battle brother will be generated\n and added to squad\n he will get twitch viewer nickname");
        }

        private void linkLabel15_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            linkLabel15.LinkVisited = true;
            MessageBox.Show("How viewer use it: write in chat !training\n if success then battle brother with twitch viewer nickname\n will be able to get some stats\n OR 1 skill point\n at your choise");
        }

        private void linkLabel16_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            linkLabel16.LinkVisited = true;
            MessageBox.Show("How viewer use it: write in chat !event\n if success then random event in game will be called");
        }

        private void linkLabel17_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            linkLabel17.LinkVisited = true;
            MessageBox.Show("How viewer use it: write in chat !craft\n if success then random item with twitch viewer nickname will be added\n also can use targeted crafting variants of command:\n !craft_weapon\n !craft_armor\n !craft_helmet\n !craft_shield");
        }

        private void linkLabel18_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            linkLabel18.LinkVisited = true;
            MessageBox.Show("How viewer use it: write in chat !perk\n if success then battle brother with twitch viewer nickname\n will get RANDOM perk\n it means he can also get NEGATIVE perks too");
        }

        private void linkLabel19_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            linkLabel19.LinkVisited = true;
            MessageBox.Show("How viewer use it: write in chat !boss\n if success then boss battle will start\n boss will have twitch viewer nickname\n random selection from variants of 6 bosses\n amount of enemies depends on size of your party");
        }

        private void linkLabel20_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            linkLabel20.LinkVisited = true;
            MessageBox.Show("How viewer use it: write in chat !duel\n if success then battle brother with twitch viewer nickname\n will be added to duel\n when duel list have 2 brothers\n they will fight automatically\n not worry they DO NOT die here");
        }

        private void linkLabel21_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            linkLabel21.LinkVisited = true;
            MessageBox.Show("How viewer use it: write in chat !casino\n if success then battle brother with twitch viewer nickname\n will be sended to break 10 casino pots\n they can contain very good loot or enemies\n be careful, brother CAN die here");
        }

        private void linkLabel22_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            linkLabel22.LinkVisited = true;
            MessageBox.Show("How viewer use it: write in chat !raid\n if success then raid preparation starts and lasts for some time\n when it goes, !raid command % chance becomes 100%\n and any viewer that write !raid will be added to raid list\n when preparation ends, they all attack your party as bandits");
        }

        private void linkLabel23_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            linkLabel23.LinkVisited = true;
            MessageBox.Show("Viewer can write in chat !day\n to get answer with current day in game");
        }

        private void linkLabel24_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            linkLabel24.LinkVisited = true;
            MessageBox.Show("Streamer can start duel manually if needed\n just write nicknames of needed viewers");
        }

        private void linkLabel25_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            linkLabel25.LinkVisited = true;
            MessageBox.Show("Streamer can start boss fight manually\n you can write number from 0 to 5 to get needed boss\n or not write anything for random");
        }

        private void linkLabel26_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            linkLabel26.LinkVisited = true;
            MessageBox.Show("Some of your viewers can be female, so\n in consideration of that you can change their battle brother\n into battle sister\n its only visual change, not affect gameplay at all");
        }

        private void linkLabel27_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            linkLabel27.LinkVisited = true;
            MessageBox.Show("You need to have patched exe for this mod and program to work!\n open \"patch\" folder here in this program folder\n you can find there iidking-v2.01.exe\n and also gog_ed.dll and steam_ed.dll\n select iidking-v2.01.exe and one dll file depening on your game version\n and copy them into game folder -> win32\n it will be something like Battle Brothers\\win32\n there must be BattleBrothers.exe inside that folder\n start iidking-v2.01.exe and press Pick a file\n select BattleBrothers.exe\n then press big button on center -> Click to pick DLL{s)\n Choose edo API in list and press \"Add them!\"\n then press \"Add them!!\"\n your exe file will be patched ok\n also you will get backup file as BattleBrothers.exe.bak\n you can restore original exe from it if you need\n now this mod and program should work normally with your game");
            Process.Start(@"patch");
        }

        private void linkLabel28_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            linkLabel28.LinkVisited = true;
            MessageBox.Show("place twitch-debug.zip into data folder in game folder\n something like \n Battle Brothers/data/twitch debug.zip");
            Process.Start(@"mod");
        }
    }
}
