CREATE TABLE [dbo].[BoatUnit] (
    [PolicyId]                       INT             NOT NULL,
    [UnitNbr]                        INT             NOT NULL,
    [PolicyNbr]                      VARCHAR (16)    NOT NULL,
    [UnitAddedDt]                    DATE            NULL,
    [UnitInceptionDt]                DATE            NULL,
    [AddressLine1Desc]               VARCHAR (100)   NULL,
    [AddressLine2Desc]               VARCHAR (100)   NULL,
    [AddressLine3Desc]               VARCHAR (100)   NULL,
    [CityNm]                         CHAR (30)       NULL,
    [LocationCountyNbr]              CHAR (3)        NULL,
    [StateOrProvinceCd]              CHAR (3)        NULL,
    [ZipCd]                          CHAR (9)        NULL,
    [BoatPurchaseDt]                 DATE            NULL,
    [BoatPurchasePriceAmt]           DECIMAL (10, 2) NULL,
    [BoatModelNm]                    VARCHAR (100)   NULL,
    [BoatMakeDesc]                   VARCHAR (100)   NULL,
    [BoatTypeCd]                     CHAR (1)        NULL,
    [BoatManyfacturingYearDt]        CHAR (4)        NULL,
    [BoatTypeDesc]                   VARCHAR (50)    NULL,
    [BoatBottomTypeDesc]             VARCHAR (50)    NULL,
    [BoatCategoryCd]                 CHAR (1)        NULL,
    [BoatUsageCd]                    CHAR (1)        NULL,
    [PropulsionTypeCd]               CHAR (1)        NULL,
    [PropulsionDesc]                 VARCHAR (50)    NULL,
    [BoatLengthNbr]                  INT             NULL,
    [HistItemHorsePowerSpeedNbr]     INT             NULL,
    [HistBoatHorsePowerNbr]          INT             NULL,
    [HistMotorYearDt]                CHAR (4)        NULL,
    [HullIdentifierNbr]              CHAR (20)       NULL,
    [HullTypeCd]                     CHAR (1)        NULL,
    [FullyEnclosedInd]               CHAR (1)        NULL,
    [RateClassCd]                    CHAR (1)        NULL,
    [BoatTypeSurchargeDiscountAmt]   DECIMAL (9, 2)  NULL,
    [SafetyCourseFCTR]               DECIMAL (4, 3)  NULL,
    [SafetyCourseDiscountAmt]        DECIMAL (9, 2)  NULL,
    [ExperienceFCTR]                 DECIMAL (4, 3)  NULL,
    [ExperiencedOperatorDiscountAmt] DECIMAL (9, 2)  NULL,
    [MiscellaneousDesc]              VARCHAR (300)   NULL,
    [UpdatedTmstmp]                  DATETIME2 (7)   NOT NULL,
    [UserUpdatedId]                  CHAR (8)        NOT NULL,
    [LastActionCd]                   CHAR (1)        NOT NULL,
    [SourceSystemCd]                 CHAR (2)        NOT NULL,
    CONSTRAINT [PK_BoatUnit] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [UnitNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_BoatUnit_BoatPolicy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[BoatPolicy] ([PolicyId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_BoatUnit_01]
    ON [dbo].[BoatUnit]([PolicyId] ASC)
    ON [POLICYCI];

