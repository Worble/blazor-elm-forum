using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApplication1.Store
{
    public class CounterStore
    {
        const int MS_MODIFIER = 100;

        //CTOR  
        public CounterStore()
        {
            this.Counter = new Counter(100, 0, new List<Building>()
                {
                    new Building(1, 1, "Building One", 0, 10),
                    new Building(2, 10, "Building Two", 0, 50)
                });
            TimeSpan startTimeSpan = TimeSpan.Zero;
            TimeSpan periodTimeSpan = TimeSpan.FromMilliseconds(MS_MODIFIER);

            System.Threading.Timer timer = new System.Threading.Timer((e) =>
            {
                this.Update();
            }, null, startTimeSpan, periodTimeSpan);
        }

        //MODEL
        public event Action OnChange;
        public Counter Counter { get; private set; }

        //UPDATE
        public int GetCount()
        {
            return (int)Math.Round(this.Counter.CurrentCount);
        }

        public void IncrementCount()
        {
            this.Counter.CurrentCount++;
        }

        public void Update()
        {
            CalculateCountPerSecond();
            this.Counter.CurrentCount += Counter.CountPerSecond / (1000 / MS_MODIFIER);
            NotifyStateChanged();
        }

        public void CalculateCountPerSecond()
        {
            double amountPerSecond = 0;
            foreach (var building in this.Counter.Buildings)
            {
                amountPerSecond += building.CalculateClicksPerSecond();
            }
            this.Counter.CountPerSecond = amountPerSecond;
        }

        public void BuyBuilding(int buildingId)
        {
            var building = Counter.Buildings.FirstOrDefault(e => e.Id == buildingId);
            if (building.Cost <= this.Counter.CurrentCount)
            {
                building.AmountOwned++;
                this.Counter.CurrentCount -= building.Cost;
                CalculateCountPerSecond();
            }
        }

        private void NotifyStateChanged() => OnChange?.Invoke();
    }

    //MODELS
    public class Counter
    {
        //CTOR
        public Counter(int currentCount, int countPerSecond, List<Building> buildings)
        {
            this.CurrentCount = currentCount;
            this.CountPerSecond = countPerSecond;
            this.Buildings = buildings;
        }

        //MODEL
        public double CurrentCount { get; internal set; } = 0;
        public double CountPerSecond { get; internal set; } = 0;
        public List<Building> Buildings { get; internal set; } = new List<Building>()
        {
            new Building(1, 1, "Building One", 0, 10),
            new Building(2, 10, "Building Two", 0, 50)
        };
    }

    public class Building
    {
        //CONSTRUCTOR
        public Building(int id, int amountPerSecond, string name, int amountOwned, int cost)
        {
            this.Id = id;
            this.AmountPerSecond = amountPerSecond;
            this.Name = name;
            this.AmountOwned = amountOwned;
            this.Cost = cost;
        }

        //MODEL
        public int Id { get; internal set; }
        public int AmountPerSecond { get; internal set; }
        public string Name { get; internal set; }
        public int AmountOwned { get; internal set; }
        public int Cost { get; internal set; }

        public double CalculateClicksPerSecond()
        {
            return this.AmountOwned * this.AmountPerSecond;
        }
    }
}
